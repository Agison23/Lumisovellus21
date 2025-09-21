document.querySelectorAll("button.next").forEach(element => {
    element.addEventListener("click", nextPage);
});

document.querySelector("button.sos").addEventListener("click", getHelp);
document.querySelector("li.pallas").addEventListener("click", nextPage);
document.querySelector("li.kartta").addEventListener("click", nextPage);
document.querySelector("button.close").addEventListener("click", closeHelp);
document.querySelector(".footer-button.location").addEventListener("click", openLocation);
document.querySelectorAll(".menu-button").forEach(element => { element.addEventListener("click", openMenu); });
document.querySelector(".menu").addEventListener("transitionend", toggleLocationDot);


function nextPage(evt) {
    let currentPage = evt.target.closest(".page");
    currentPage.style.left = "-100vw";
    currentPage.nextElementSibling.style.left = "0";
}

function previousPage(evt) {
    let currentPage = evt.target.closest(".page");
    currentPage.style.left = "100vw";
    currentPage.previousElementSibling.style.left = "0";
}

function getHelp(evt) {
    document.querySelector(".help").classList.remove("d-none");
    document.querySelector(".your-location").classList.toggle("d-none");
}

function closeHelp(evt) {
    document.querySelector(".help").classList.add("d-none");
    document.querySelector(".your-location").classList.toggle("d-none");
}

function openLocation(evt) {
    document.querySelector(".location-screen").classList.toggle("d-none");
    document.querySelector(".your-location").classList.toggle("d-none");
}

function openMenu(evt) {
    document.querySelector(".menu").classList.toggle("open");
}

function toggleLocationDot(params) {
    document.querySelector(".your-location").classList.toggle("d-none");    
}