export default {
  showMore(expanded: boolean): string {
    if (expanded) {
      return MyZivi.translations.search.refinements.controls.showLess;
    }

    return MyZivi.translations.search.refinements.controls.showMore;
  },
  noResults: MyZivi.translations.search.refinements.controls.noResults,
  submitTitle: MyZivi.translations.search.refinements.controls.submitTitle,
  resetTitle: MyZivi.translations.search.refinements.controls.resetTitle,
  placeholder: MyZivi.translations.search.refinements.controls.placeholder,
};
