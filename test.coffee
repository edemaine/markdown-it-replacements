assert = require 'assert'

markdownIt = require 'markdown-it'
markdownItReplacements = require '.'

test = (text, options, typographer = true) ->
  md = markdownIt
    typographer: typographer
  .use markdownItReplacements, options
  md.renderInline text

describe 'markdown-it-replacements', ->
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
