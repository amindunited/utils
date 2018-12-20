/**
 * @license
 * Copyright Robin Buckley. All Rights Reserved.
 *
 * Use of this source code is governed by an MIT-style license that can be
 * found in the LICENSE file
 */
'use strict';

const fs = require('fs');
const processFunctions = require('./process');
const expect = require('chai').expect

describe('Process Functions', () => {

  it('should export an object', () => {
    expect(processFunctions).to.be.an('object');
  });

  it('should export process info', () => {
    expect(processFunctions.processInfo).to.be.a('function');
  });

  it('should export git info', () => {
    expect(processFunctions.gitInfo).to.be.a('function');
  });

});
