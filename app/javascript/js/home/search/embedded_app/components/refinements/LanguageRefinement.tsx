import { RefinementList } from 'react-instantsearch-dom';
import React from 'preact/compat';
import defaultTranslations from './defaultTranslations';

// class LanguageRefinement extends React.PureComponent {
//   componentDidUpdate(previousProps: Readonly<{}>, previousState: Readonly<{}>, snapshot: any) {
//     // eslint-disable-next-line
//     console.log('LanguageRefinement updated');
//   }
//
//   // eslint-disable-next-line
//   render() {
//     return (
//       <RefinementList
//         attribute="language"
//         searchable={false}
//         limit={5}
//         translations={defaultTranslations}
//         transformItems={
//           (items) => items.map((item) => (
//             { ...item, label: MyZivi.translations.search.refinements.languages[item.label] }
//           ))
//         }
//         showMore
//       />
//     );
//   }
// }

const LanguageRefinement: React.FunctionComponent = () => (
  <RefinementList
    attribute="language"
    searchable={false}
    limit={5}
    translations={defaultTranslations}
    transformItems={
      (items) => items.map((item) => (
        { ...item, label: MyZivi.translations.search.refinements.languages[item.label] }
      ))
    }
    showMore
  />
);

// TODO: React.memo shouldn't be used to control render. However, I still do it to prevent a weird re-rendering bug.
//       Having a transformItems causes the refinement list to infinitely re-render. I don't know why.
export default React.memo(LanguageRefinement, () => true);
// export default LanguageRefinement;
