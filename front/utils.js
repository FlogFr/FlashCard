export function openFullScreenMenu() {
  document.getElementById('fullscreen-menu').style.visibility = "visible";
}

export function closeFullScreenMenu() {
  document.getElementById('fullscreen-menu').style.visibility = "hidden";
}

export function newQuizzTimeout() {
    setTimeout(
        () => {
            window.location = "/quizz";
        },
        3000
    );
}
