// demo.js

document.addEventListener('DOMContentLoaded', () => {
  const txt = document.getElementById('myText');

  // 1️⃣ set via attribute
  txt.setAttribute('fill', '#0066ff');

  // 2️⃣ later, replace via style property
  setTimeout(() => {
    txt.style.fill = 'purple';
  }, 1500);

  // 3️⃣ finally, switch using a CSS class
  setTimeout(() => {
    txt.classList.remove('big-red');
    txt.classList.add('green');   // .green defined in the stylesheet
  }, 3000);
});
