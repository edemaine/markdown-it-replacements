###
These regular expressions are based on
https://github.com/markdown-it/markdown-it/blob/master/lib/rules_core/replacements.js
(also distributed under MIT License)
###

replacements = [
  name: 'plusminus'
  re: /\+-/g
  sub: '\u00b1' ## ±
  default: true
,
  name: 'ellipsis'
  re: /\.\.\./g
  sub: '\u2026' ## …
  default: true
,
  name: 'mdash'
  re: /(^|[^-])---([^-]|$)/mg
  sub: '$1\u2014$2'
  default: true
,
  name: 'ndash'
  re: /(^|[^-])--([^-]|$)/mg
  sub: '$1\u2013$2'
  default: true
,
  name: 'ndash'
  re: /(^|[^-\s])--([^-\s]|$)/mg
  sub: '$1\u2013$2'
  default: true
]

module.exports = (md, options = {}) ->
  ## Replace existing replacements rule.
  md.core.ruler.at 'replacements', (state) ->
    ## If we're using this package, probably we meant to use it,
    ## not just when setting the typographer option.
    #return unless state.md.options.typographer
    for i in [0...state.tokens.length].reverse()
      block = state.tokens[i]
      continue unless block.type == 'inline'

      inside_autolink = 0
      for j in [0...block.children.length].reverse()
        token = block.children[j]
        switch token.type
          when 'link_open'
            inside_autolink -= 1 if token.info == 'auto'
          when 'link_close'
            inside_autolink += 1 if token.info == 'auto'
          when 'text'
            unless inside_autolink
              for replacement in replacements
                ## Use replacement according to options setting (true or
                ## false), resorting to default if undefined or null.
                if options[replacement.name] ? replacement.default ? true
                  token.content = token.content.replace replacement.re, replacement.sub
    null
  null

###
Export replacements array so that user can add their own rules.
For example: require('markdown-it-replacements').replacements.push({...})
###
module.exports.replacements = replacements
