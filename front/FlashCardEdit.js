import React from 'react';
import ReactDOM from 'react-dom';

export function addTag(elt) {
    console.log('add tag');
    console.log(elt);
    var newDiv = document.createElement("div");
    elt.previousElementSibling.append(
        newDiv,
    );
    ReactDOM.render(
        <FlashCardTagInput />,
        newDiv
    );
}

export function removeTag(elt) {
    elt.parentElement.remove();
}

export class FlashCardTagInput extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
        unmount: false,
    }

    this.onRemove = this.onRemove.bind(this);
  }

  onRemove = () => {
    this.setState({
        unmount: true,
    });
  }

  render() {
      const {unmount} = this.state;

      if (unmount) {
        return null;
      } else {
        return (
            <div className="flashcard-tag-container">
                <input type="text" name="tag" />
                <a href="#" onClick={this.onRemove} ><span className="icon-delete">Delete tag</span></a>
            </div>
        )
      }
  }
}
