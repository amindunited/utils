/**
 * @license
 * Copyright Robin Buckley. All Rights Reserved.
 *
 * Use of this source code is governed by an MIT-style license that can be
 * found in the LICENSE file
 */
'use strict';

const fs = require('fs');
const fileSystemFunctions = require('./file-system');
const expect = require('chai').expect

describe('File System Functions', () => {

  it('should export an object', () => {
    expect(fileSystemFunctions).to.be.an('object');
  });

  it('should export copy file', () => {
    expect(fileSystemFunctions.copyFile).to.be.a('function');
  });

  it('should export ensure path', () => {
    expect(fileSystemFunctions.ensurePath).to.be.a('function');
  });

  it('should export move file', () => {
    expect(fileSystemFunctions.moveFile).to.be.a('function');
  });

});
