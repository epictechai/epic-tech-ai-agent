/* Epic Tech AI — shared docs chrome */
(function () {
  const year = new Date().getUTCFullYear();
  document.querySelectorAll("[data-year]").forEach((el) => {
    el.textContent = year;
  });
})();
