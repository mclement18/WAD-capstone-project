const Stage = {};

Stage.getStages = function() {
  return document.querySelectorAll('.stage');
};

Stage.getTravelTypeOptions = function() {
  return JSON.parse(document.querySelector('meta[name=travelTypesOptions]').getAttribute('value'));
};

Stage.buildTravelTypeSelect = function(stageNb) {
  const select = document.createElement('select');
  select.id = `stage_${stageNb}_travel_type`;
  select.className = 'input-field input-field--select';
  select.name = `trip[stages][stage_${stageNb}][travel_type]`;
  select.innerHTML = this.getTravelTypeOptions();
  return select;
};

Stage.buildLabelForTravelType = function(stageNb) {
  const label = document.createElement('label');
  label.className = 'input-label';
  label.setAttribute('for', `stage_${stageNb}_travel_type`);
  label.textContent = document.querySelector('meta[name=travelTypeLabel]').getAttribute('value');
  return label;
};

Stage.renameStageIdInput = function(stage, stageNb) {
  const label = stage.querySelector('.stage__id label');
  label.setAttribute('for', `stage_${stageNb}_stage_id`);
  label.textContent = [label.textContent.split(' ')[0], stageNb.toString()].join(' ');

  const input = stage.querySelector('.stage__id input');
  input.id = `stage_${stageNb}_stage_id`;
  input.name = `trip[stages][stage_${stageNb}][stage_id]`;
};

Stage.renameTravelTypeInput = function(parent, stageNb) {
  const label = parent.querySelector('label');
  label.setAttribute('for', `stage_${stageNb}_travel_type`);

  const select = parent.querySelector('select');
  select.id = `stage_${stageNb}_travel_type`;
  select.name = `trip[stages][stage_${stageNb}][travel_type]`;
};

Stage.removeTravelTypeInput = function(parent) {
  parent.removeChild(parent.querySelector('label'));
  parent.removeChild(parent.querySelector('select'));
};

Stage.addTravelTypeInput = function(parent, stageNb) {
  parent.appendChild(this.buildLabelForTravelType(stageNb));
  parent.appendChild(this.buildTravelTypeSelect(stageNb));
};

Stage.reorder = function() {
  for (let i = 0; i < this.getStages().length; i++) {
    const stage = this.getStages()[i];
    const stageNb = i + 1;
    
    this.renameStageIdInput(stage, stageNb);
    const travelTypeContainer = stage.querySelector('.stage__travel-type')

    if (stageNb === 1) {
      if (travelTypeContainer.children.length > 1) {
        this.removeTravelTypeInput(travelTypeContainer);
      }
    } else {
      if (travelTypeContainer.children.length === 1) {
        this.addTravelTypeInput(travelTypeContainer, stageNb);
      } else if (travelTypeContainer.children.length > 1) {
        this.renameTravelTypeInput(travelTypeContainer, stageNb);
      }
    }
  }
};
