/**
 * @license
 * Copyright Robin Buckley. All Rights Reserved.
 *
 * Use of this source code is governed by an MIT-style license that can be
 * found in the LICENSE file
 */
'use strict';

const fs = require('fs');
const arrayFunctions = require('./array');
const expect = require('chai').expect

describe('Array Functions', () => {

  it('should export an object', () => {
    expect(arrayFunctions).to.be.an('object');
  });

  it('should export deep flatten', () => {
    expect(arrayFunctions.deepFlatten).to.be.a('function');
  });

  it('should export exclude', () => {
    expect(arrayFunctions.exclude).to.be.a('function');
  });

});
