import * as React from 'react';
import { RefObject } from 'react';

//tslint:disable:no-any

/**
 * This TR's onClick only triggers when the TR or its direct TD children are clicked.
 * Any other elements (like buttons inside a cell) won't trigger it.
 */
export class SafeClickableTableRow extends React.Component<any> {
  public ref: RefObject<any>;

  constructor(props: any) {
    super(props);
    this.ref = React.createRef();
  }

  handleClick = (e: React.MouseEvent<HTMLElement>) => {
    const tr = this.ref.current;
    const children = Array.from(tr.children);
    if (e.target === tr || children.find(el => el === e.target)) {
      this.props.onClick(e);
    } else {
      // console.log("NOPE", this.ref, e)
    }
  };

  render = () => {
    const { children, ...rest } = this.props;
    return (
      <tr ref={this.ref} {...rest} onClick={this.handleClick}>
        {children}
      </tr>
    );
  };
}
