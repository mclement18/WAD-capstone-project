const Input = {};

Input.changeFileTriggerText = function(fileTrigger, inputFile) {
  fileTrigger.textContent = inputFile.value.split('\\').pop();
};

Input.addChangeEventToInputFile = function() {
  document.addEventListener('change', event => {
    const target = event.target;
    if (target.classList.contains('input-file')) {
      if (target.nextElementSibling && target.nextElementSibling.id === 'fileTrigger') {
        this.changeFileTriggerText(target.nextElementSibling, target);
      } else if (target.parentElement.nextElementSibling.id === 'fileTrigger') {
        this.changeFileTriggerText(target.parentElement.nextElementSibling, target);
      }
    }
  });
};

Input.addChangeEventToInputFile();
