import React from 'react';
import ReactDOM from 'react-dom';

import { TopNavigation } from "./TopNavigation.jsx";

import {openFullScreenMenu, closeFullScreenMenu, newQuizzTimeout} from './utils.js';
import {addTag, removeTag} from './FlashCardEdit.js';

window.onload = function() {
    if (window.location.pathname === "/") {
        // pathname
    }
    
    // Top Navigation for user
    if (typeof backendVariables !== 'undefined' && typeof backendVariables.session !== 'undefined' && typeof backendVariables.session.user.id !== 'undefined') {
        ReactDOM.render(
        <TopNavigation user={backendVariables.session.user}/>,
        document.getElementById('top-navigation-user')
        );
    }
}


// export global context / window context the function needed
// by the attribute onclick=
window.openFullScreenMenu = openFullScreenMenu;
window.closeFullScreenMenu = closeFullScreenMenu;
window.addTag = addTag;
window.removeTag = removeTag;
window.newQuizzTimeout = newQuizzTimeout;
