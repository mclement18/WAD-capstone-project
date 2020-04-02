module TripStagesReordering

  def validates_all(trip, new_order)
    validator = Validator.new trip, new_order
    validator.validates_all
  end

  def validates_stages_number(trip, new_order)
    validator = Validator.new trip, new_order
    validator.validates_stages_number
  end

  def validates_stage_ids
    validator = Validator.new trip, new_order
    validator.validates_stage_ids
  end

  def validates_travel_types
    validator = Validator.new trip, new_order
    validator.validates_travel_types
  end

  def reorder_stages(trip, new_order)
    organizer = Organizer.new trip, new_order
    organizer.reorder_stages
  end
  
  class Base
    # trip is an instance of Trip model
    # new_order is an hash with the following structure:
    # new_order = {
    #   stage_1: {
    #     stage_id: Integer,    # Can any type that can output a valid Integer via the method .to_i
    #     travel_type: String   # A String that is a valid option for the attribute travel_type of the Stage model
    #   },
    #   stage_2: {
    #     stage_id: Integer,
    #     travel_type: String
    #   },
    #   ...
    #   stage_n: {
    #     stage_id: Integer,
    #     travel_type: String
    #   }
    # }
    def initialize(trip, new_order)
      raise TypeError, "for trip param, expected an instance of Trip, got #{trip.class.name}" unless trip.class == Trip
      raise TypeError, "for new_order param, expected an ActionController::Parameters, got #{new_order.class.name}" unless new_order.class == ActionController::Parameters
      @trip = trip
      @new_order = new_order.to_h
    end
  end
  
  class Validator < Base
    def initialize(trip, new_order)
      super(trip, new_order)
      @stages = @trip.stages
      @errors = Errors.new
    end

    def validates_all
      validates_stages_number
      validates_stage_ids
      validates_travel_types
      @errors
    end

    def validates_stages_number
      error = nil
      if @stages.length != @new_order.length || @new_order.empty?
        error = I18n.t('errors.ids_not_match')
      end
      @errors.messages << error if error
      error
    end

    def validates_stage_ids
      error = nil
      stages_ids = []
      @stages.each do |stage|
        stages_ids << (stage.id)
      end
      
      @new_order.each do |stage, values|
        id = values[:stage_id].to_i
        error = I18n.t('errors.ids_invalid') unless stages_ids.include?(id)
      end

      @errors.messages << error if error
      error
    end

    def validates_travel_types
      error = nil
      @new_order.each do |stage, values|
        travel_type = values[:travel_type]
        unless Stage.valid_travel_types.include?(travel_type)
          error = I18n.t('errors.travel_types_invalid')
          break
        end
      end

      @errors.messages << error if error
      error
    end

    class Errors
      attr_accessor :messages
      
      def initialize
        @messages = []
      end

      def to_s
        @messages.join(' ')
      end
    end
  end

  class Organizer < Base
    def initialize(trip, new_order)
      super(trip, new_order)
    end
    
    def reorder_stages
      update_next = false
      previous_address = nil
      save_success = true
      
      # Process from stage number 1 to the end
      1.upto(@new_order.length) do |i|
        stage_id = @new_order["stage_#{i}".to_sym][:stage_id]
        travel_type = @new_order["stage_#{i}".to_sym][:travel_type]
        current_stage = Stage.find_by(id: stage_id, trip_id: @trip.id)

        # Disable callback to handle next stage update here
        current_stage.update_next_stage_directions = false
        
        # Set stage number
        current_stage.number = i
  
        # Set stage travel_type
        set_travel_type(i, current_stage, travel_type)
        
        # Update stage directions
        update_directions(current_stage, previous_address, update_next)
        
        # Record address to update next stage directions and avoid another call to the database
        previous_address = current_stage.address
        
        # Save stage. If directions was updated it won't update again and if not it will update if travel_type changed
        save_success = current_stage.save
        break unless save_success
      end
      save_success
    end

    private

    def set_travel_type(stage_number, current_stage, travel_type)
      if stage_number == 1
        current_stage.travel_type = 'None'
      elsif travel_type == 'None'
        current_stage.travel_type = 'driving' # default to driving if not set to calculate directions
      else
        current_stage.travel_type = travel_type
      end
    end

    def update_directions(current_stage, previous_address, update_next)
      if current_stage.will_save_change_to_number?
        # Set directions if number was changed
        # Indicate to update next stage directions (because stage was moved)
        current_stage.set_directions!(previous_address)
        update_next = true
      else
        # Set directions only if travel_type did not changed and previous stage was moved
        # Indicate no to update next stage directions (because stage was not moved)
        current_stage.set_directions!(previous_address) if !current_stage.will_save_change_to_travel_type? && update_next
        update_next = false
      end
    end
  end
end
