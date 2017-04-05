# markdown-it-replacements
This [markdown-it](https://github.com/markdown-it/markdown-it) plugin
replaces the
"[replacements](https://github.com/markdown-it/markdown-it/blob/master/lib/rules_core/replacements.js)"
feature in markdown-it typographer, allowing you to customize the replacement
rules (regular expression substitutions) done to inline text outside of
autolinks.

There are four built-in replacement rules (mimicking some of the built-in
markdown-it typographer):

* `+-` &rarr; ± (rule "plusminus")
* `...` &rarr; … (rule "ellipsis")
* `---` &rarr; &mdash; (rule "mdash")
* `--` &rarr; &ndash; (rule "ndash")

Each rule can be turned off by specifying an option object when using the
module (mapping each undesired rule name to `false`).
Additional rules can be added by modifying the `replacements` module attribute
(an array of rules, where each `rule` has a name `rule.name`,
regular expression `rule.re`, substitution `rule.sub`, and boolean
default on/off `rule.default`).

## Sample Usage

```javascript
// Without smart quotes
md = require('markdown-it')()
.use(require('markdown-it-replacements'));
md.renderInline('Hello... "world"---');
          // -> 'Hello… &quot;world&quot;—'

// With smart quotes
md = require('markdown-it')({typographer: true})
.use(require('markdown-it-replacements'));
md.renderInline('Hello... "world"---');
          // -> 'Hello… “world”—'

// Using options to turn specific replacements on/off
md = require('markdown-it')({typographer: true})
.use(require('markdown-it-replacements'), {mdash: false});
md.renderInline('Hello... "world"---');
          // -> 'Hello… “world”---'

// Adding custom replacements
mir = require('markdown-it-replacements');
mir.replacements.push({
  name: 'allcaps',
  re: /[a-z]/g,
  sub: function (s) { return s.toUpperCase(); },
  default: true
});
md = require('markdown-it')({typographer: true}).use(mir);
md.renderInline('Hello... "world"---');
          // -> 'HELLO… “WORLD”—'

```

## Notes

* Unlike the built-in replacements rule, this module does not require
  the global `typographer` option to be set to true.  (The reasoning being
  that, if you're using this module, you probably want to do the
  substitutions.)  This means that the `typographer` option effectively
  controls whether to do smart-quote substitution.
