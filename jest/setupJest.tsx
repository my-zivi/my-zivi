import { configure } from 'enzyme';
import Adapter from 'enzyme-adapter-preact-pure';

// eslint-disable-next-line @typescript-eslint/no-var-requires, @typescript-eslint/no-explicit-any
(global as any).h = require('preact').h;

configure({ adapter: new Adapter() });
