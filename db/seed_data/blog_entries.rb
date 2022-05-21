# frozen_string_literal: true

BlogEntry.create!(
  title: 'Lorem Ipsum',
  subtitle: 'About a latin journey',
  description: 'Why is Lorem so popular?',
  author: 'Marcus Tullius Cicero',
  published: true,
  tags: ['article'],
  content: <<~TEXT.squish
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus vel dolor nec leo mattis viverra eu et tellus.
    Cras faucibus, augue vel dictum tempor, leo metus facilisis risus, ut consectetur diam erat id leo. Suspendisse
    tincidunt libero sit amet magna sodales sodales. Cras convallis magna a arcu mollis finibus. Proin tortor lacus,
    viverra nec tempus non, blandit vitae risus. Sed luctus eros a ipsum dapibus, id dictum tellus sollicitudin. Quisque
    interdum laoreet tellus blandit iaculis. Donec consequat tellus vitae vulputate elementum.
  TEXT
)

BlogEntry.create!(
  title: 'How I became a developer',
  subtitle: 'About a programmer journey',
  description: 'Why are programmers so popular?',
  author: 'Anon Ymous',
  published: true,
  tags: %w[article news],
  content: <<~TEXT.squish
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus vel dolor nec leo mattis viverra eu et tellus.
    Cras faucibus, augue vel dictum tempor, leo metus facilisis risus, ut consectetur diam erat id leo. Suspendisse
    tincidunt libero sit amet magna sodales sodales. Cras convallis magna a arcu mollis finibus. Proin tortor lacus,
    viverra nec tempus non, blandit vitae risus. Sed luctus eros a ipsum dapibus, id dictum tellus sollicitudin. Quisque
    interdum laoreet tellus blandit iaculis. Donec consequat tellus vitae vulputate elementum.
TEXT
)


puts '> Blog entries seeded'
