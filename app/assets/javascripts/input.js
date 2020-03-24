const Input = {};

Input.addChangeEventToInputFile = function() {
  document.addEventListener('change', event => {
    const target = event.target;
    if (target.classList.contains('input-file')) {
      target.nextElementSibling.textContent = target.value.split('\\').pop();
    }
  });
};

Input.addChangeEventToInputFile();
