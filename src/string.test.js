/**
 * @license
 * Copyright Robin Buckley. All Rights Reserved.
 *
 * Use of this source code is governed by an MIT-style license that can be
 * found in the LICENSE file
 */
'use strict';

const fs = require('fs');
const stringFunctions = require('./string');
const expect = require('chai').expect

describe('Process Functions', () => {

  it('should export an object', () => {
    expect(stringFunctions).to.be.an('object');
  });

  it('should export to camel case', () => {
    expect(stringFunctions.toCamelCase).to.be.a('function');
  });

  it('should export to kebab case', () => {
    expect(stringFunctions.toKebabCase).to.be.a('function');
  });

  it('should export to title case', () => {
    expect(stringFunctions.toTitleCase).to.be.a('function');
  });

  it('should export to snek case', () => {
    expect(stringFunctions.toSnakeCase).to.be.a('function');
  });

  it('should export revision hash', () => {
    expect(stringFunctions.revisionHash).to.be.a('function');
  });

});
