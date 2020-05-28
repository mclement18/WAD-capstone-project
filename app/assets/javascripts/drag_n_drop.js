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
  return document.querySelector(`#${event.dataTransfer.getData('text/plain')}`);
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
