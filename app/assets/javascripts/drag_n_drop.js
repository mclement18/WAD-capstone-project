const DragNDrop = {};

DragNDrop.counter = 0;

DragNDrop.getDraggables = function() {
  return document.querySelectorAll('.draggable-field[draggable=true]');
};

DragNDrop.getAvailableDropZones = function() {
  return document.querySelectorAll('.draggable-field.can-drop');
};

DragNDrop.getUpperDropZones = function() {
  return document.querySelectorAll('.dropzone.drop-before');
}

DragNDrop.getLowerDropZones = function() {
  return document.querySelectorAll('.dropzone.drop-after');
}

DragNDrop.getFormInput = function() {
  return document.querySelector('.drag-drop-form .form__input');
};

DragNDrop.getDraggedField = function(event) {
  return document.getElementById(event.dataTransfer.getData('text/plain'));
};

DragNDrop.validatesDropZone = function(target) {
  let dropZone = null;
  this.getAvailableDropZones().forEach(element => {
    if (target.parentElement.id === element.id) {
      dropZone = target.parentElement;
    }
  });
  return dropZone;
};

DragNDrop.onStart = function(element) {
  element.addEventListener('dragstart', event => {
    const target = event.target;
    event.dataTransfer.setData('text/plain', target.id);
    event.dataTransfer.dropEffect = "move";
    target.classList.add('draggable-field--dragged');
    target.classList.remove('can-drop');
  });
};

DragNDrop.onEnd = function(element) {
  element.addEventListener('dragend', event => {
    event.target.classList.remove('draggable-field--dragged');
    event.target.classList.add('can-drop');
  });
};

DragNDrop.onDrop = function(element) {
  element.addEventListener('drop', event => {
    event.preventDefault();
    const target = event.target;
    const targetField = this.validatesDropZone(target);
    if (targetField && target.classList.contains('dropzone')) {
      targetField.classList.remove('draggable-field--hovered');
      target.classList.remove('dropzone--hovered');
      this.counter = 0;
      const movedField = this.getDraggedField(event);
      this.getFormInput().removeChild(movedField);
      if (target.classList.contains('drop-before')) {
        this.getFormInput().insertBefore(movedField, targetField);
      } else if (target.classList.contains('drop-after')) {
        this.getFormInput().insertBefore(movedField, targetField.nextElementSibling);
      }
      Stage.reorder();
    }
  });
};

DragNDrop.onEnter = function(element) {
  element.addEventListener('dragenter', event => {
    event.preventDefault();
    const target = event.target;
    const targetField = this.validatesDropZone(target);
    if (targetField && target.classList.contains('dropzone')) {
      event.dataTransfer.dropEffect = 'move';
      targetField.classList.add('draggable-field--hovered');
      target.classList.add('dropzone--hovered');
      this.counter++;
    }
  });
};

DragNDrop.onLeave = function(element) {
  element.addEventListener('dragleave', event => {
      const target = event.target;
      const targetField = this.validatesDropZone(target);
      if (targetField && target.classList.contains('dropzone')) {
        target.classList.remove('dropzone--hovered');
        this.counter--;
        if (this.counter === 0) {
          targetField.classList.remove('draggable-field--hovered');
        }
      }
    });
};

DragNDrop.onOver = function(element) {
  element.addEventListener('dragover', event => {
    event.preventDefault();
  });
};

DragNDrop.addEventListeners = function() {
  document.addEventListener('turbolinks:load', () => {
    this.getDraggables().forEach(element => {
      this.onStart(element);
      this.onEnd(element);
      this.onDrop(element);
      this.onEnter(element);
      this.onLeave(element);
      this.onOver(element);
    });
  });
};

DragNDrop.addEventListeners();


// window['moment-range'].extendMoment(moment);

// const parkingSimulation = (function () {
// 	const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
// 	const parkingSimulation = {
// 		parkingRules: {
// 			ambulance: {
// 				days: weekdays,
// 				times: createRange(moment().set('hour', 21), moment().add(1, 'day').set('hour', 3))
// 			},
// 			'fire truck': {
// 				days: ['Saturday', 'Sunday']
// 			},
// 			car: {
// 				days: weekdays,
// 				times: createRange(moment().set('hour', 3), moment().set('hour', 15))
// 			},
// 			bicycle: {
// 				days: weekdays,
// 				times: createRange(moment().set('hour', 15), moment().set('hour', 21))
// 			}
// 		},
// 		dropZone: document.querySelector('.drop-zone'),
// 		vehicleArray: [...document.querySelectorAll('.vehicles img')],
// 		dragged: null,
// 		areVehiclesFiltered: false
// 	}
// 	return Object.seal(parkingSimulation);
// })();

// function addEventListeners() {
// 	const filterButton = document.querySelector('.drag-vehicle .filter-vehicles');
// 	const showButton = document.querySelector('.drag-vehicle .show-all');
// 	const vehicles = document.querySelector('.vehicles');
// 	const dropZone = parkingSimulation.dropZone;

// 	vehicles.addEventListener('dragstart', onDragStart);
// 	vehicles.addEventListener('dragend', onDragEnd);
// 	dropZone.addEventListener('drop', onDrop);
// 	dropZone.addEventListener('dragenter', onDragEnter);
// 	dropZone.addEventListener('dragleave', onDragLeave);
// 	dropZone.addEventListener('dragover', onDragOver);
// 	filterButton.addEventListener('click', showVehiclesThatCanPark);
// 	showButton.addEventListener('click', resetVehicles);
// }

// function createRange(start, end) {
// 	if (start && end) {
// 		return moment.range(start, end);
// 	}
// }

// function onDragStart(event) {
// 	let target = event.target;
// 	if (target && target.nodeName == 'IMG') {
// 	    // Store a ref. on the dragged elem
// 	    const imgSrc = target.src;
// 	    parkingSimulation.dragged = target;
// 	    event.dropEffect = 'linkMove';
// 	    event.dataTransfer.setData('text/uri-list', imgSrc);
// 	    event.dataTransfer.setData('text/plain', imgSrc);

// 	    // Make it half transparent
// 	    event.target.style.opacity = .5;
// 	}
// }

// function onDragEnd(event) {
// 	if (event.target && event.target.nodeName == 'IMG') {
// 	    // Reset the transparency
// 	    event.target.style.opacity = '';
// 	}
// }

// function contains(list, value) {
// 	for (let i = 0; i < list.length; ++i) {
// 		if (list[i] === value) return true;
// 	}
// 	return false;
// }

// function onDragOver(event) {
//   // Prevent default to allow drop
//   event.preventDefault();
// }

// function validateTarget(target) {
// 	const dropZone = parkingSimulation.dropZone;
// 	return (target.parentNode === dropZone || target === dropZone) ? dropZone : null;
// }

// function onDragLeave(event) {
// 	const target = validateTarget(event.target);
// 	target.style.background = '';
// }

// function onDragEnter(event) {
// 	const target = validateTarget(event.target);
// 	const dragged = parkingSimulation.dragged;
// 	if (dragged && target) {
// 		const isLink = contains(event.dataTransfer.types, 'text/uri-list');
// 		const vehicleType = dragged.alt;
// 		if (isLink && canPark(vehicleType)) {
// 			event.preventDefault();
// 			// Set the dropEffect to move
// 			event.dataTransfer.dropEffect = 'linkMove'
// 			target.style.background = '#1f904e';
// 	 	}
// 	 	else {
// 		  	target.style.backgroundColor = '#d51c00';
// 		}
// 	}
// }

// function onDrop(event) {
// 	const target = validateTarget(event.target);
// 	const dragged = parkingSimulation.dragged;
// 	if (dragged && target) {
// 		const isLink = contains(event.dataTransfer.types, 'text/uri-list');
// 		const vehicleType = dragged.alt;
// 		target.style.backgroundColor = '';
// 		if (isLink && canPark(vehicleType)) {
// 		   event.preventDefault();
// 	       // Get the id of the target and add the moved element to the target's DOM
// 	       dragged.parentNode.removeChild(dragged);
// 	       dragged.style.opacity = '';
// 	       target.appendChild(dragged);
// 	  	 }
// 	}
// }

// function getDay() {
// 	return moment().format('dddd');
// }

// function getHours() {
// 	return moment().hour();
// }

// function canPark(vehicle) {
// 	// Check the time and the type of vehicle being dragged to see if it can park at this time
// 	const parkingRules = parkingSimulation.parkingRules;
// 	if (vehicle && parkingRules[vehicle]) {
// 		const rules = parkingRules[vehicle];
// 		const validDays = rules.days;
// 		const validTimes = rules.times;
// 		const curDay = getDay();
// 		if (validDays) {
// 			return validDays.includes(curDay) && (validTimes ? validTimes.contains(moment()) : true); 
// 		}
// 	}
// 	return false;
// }

// function showVehiclesThatCanPark() {
// 	parkingSimulation.vehicleArray.filter((vehicle) => {
// 		return !canPark(vehicle.alt);
// 	}).forEach((vehicle) =>{
//     	vehicle.classList.add('hide');
// 	});
// 	parkingSimulation.areVehiclesFiltered = true;
// }

// function resetVehicles() {
// 	if (parkingSimulation.areVehiclesFiltered) {
// 		parkingSimulation.vehicleArray.forEach((vehicle) => {
// 	    	vehicle.classList.remove('hide');
// 		});
// 		parkingSimulation.areVehiclesFiltered = false;
// 	}
// }
// addEventListeners();