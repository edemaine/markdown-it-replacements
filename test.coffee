assert = require 'assert'

markdownIt = require 'markdown-it'
markdownItReplacements = require '.'

test = (text, options, typographer = true) ->
  md = markdownIt
    typographer: typographer
  .use markdownItReplacements, options
  md.renderInline text

describe 'markdown-it-replacements', ->
  it 'blank values', ->
    assert.equal '', test ''
  it 'override (c) replacement behavior', ->
    assert.equal '(c)', test '(c)'
  it 'ndash', ->
    assert.equal '1\u20139', test '1--9'
  it 'mdash', ->
    assert.equal 'yes\u2014or no', test 'yes---or no'
  it 'ellipsis', ->
    assert.equal 'yes\u2026', test 'yes...'
  it 'plus minus', ->
    assert.equal '1 \u00b1 100', test '1 +- 100'
  it 'override ndash', ->
    assert.equal '1--9', test '1--9', ndash: false
  it 'override mdash', ->
    assert.equal 'yes---or no', test 'yes---or no', mdash: false
  it 'override ellipsis', ->
    assert.equal 'yes...', test 'yes...', ellipsis: false
  it 'override plus minus', ->
    assert.equal '1 +- 100', test '1 +- 100', plusminus: false
  it 'runs even with typographer set to false', ->
    assert.equal '1\u20139', test '1--9', {}, false
  it 'custom replacement, no default', ->
    markdownItReplacements.replacements.push
      name: 'allcaps',
      re: /[a-z]/g,
      sub: (s) -> s.toUpperCase()
    assert.equal 'HELLO', test 'hello'
  it 'custom replacement, default true', ->
    markdownItReplacements.replacements[markdownItReplacements.replacements.length-1].default = true
    assert.equal 'HELLO', test 'hello'
  it 'custom replacement, default false', ->
    markdownItReplacements.replacements[markdownItReplacements.replacements.length-1].default = false
    assert.equal 'hello', test 'hello'
