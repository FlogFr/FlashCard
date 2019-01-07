import React, {Component} from 'react';
import ReactDOM, { render } from 'react-dom';

import { FullscreenNavigation } from './FullscreenNavigation.jsx';

export class TopNavigation extends Component {

  constructor(props) {
    super(props);

    this.onOpenFullscreenMenu = this.onOpenFullscreenMenu.bind(this);
  }

  componentDidMount() {
  }

  onOpenFullscreenMenu(e) {
    const {user} = this.props;

    e.preventDefault();
    ReactDOM.render(
      <FullscreenNavigation user={user} />,
      document.getElementById('fullscreen-menu')
    );
    openFullScreenMenu();
  }

  render() {
    return (
        <ul>
            <li>
                <a onClick={this.onOpenFullscreenMenu} className="container-lines" >
                    <span className="lines"></span>
                </a>
            </li>
        </ul>
  );
  }

}
