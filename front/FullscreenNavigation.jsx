import React, {Component} from 'react';
import { render } from 'react-dom';
import {closeFullScreenMenu} from './utils.js';

export class FullscreenNavigation extends Component {

  constructor(props) {
    super(props);

    this.hideFullscreenMenu = this.hideFullscreenMenu.bind(this);
  }

  hideFullscreenMenu(e) {
      e.preventDefault();
      closeFullScreenMenu();
  }

  render() {
    return (
      <React.Fragment>
        <a onClick={this.hideFullscreenMenu} className="container-close" >
            <span className="icon-close"></span>
        </a>
        <ul>
            <a href="/account"><li>
                My account <span className="icon-user"></span>
            </li></a>
            <a href="/dashboard"><li>
                Dashboard <span className="icon-home"></span>
            </li></a>
            <a href="/flashcard/add"><li>
                Add a FlashCard <span className="icon-add"></span>
            </li></a>
            <a href="/quizz"><li>
                Take a quizz <span className="icon-quizz"></span>
            </li></a>
            <a><li>
                <form action="/logout" method="post" ><input type="submit" value="Log out" /></form>
            </li></a>
        </ul>
      </React.Fragment>
    );
  }

}
