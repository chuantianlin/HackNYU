const ImageToken = artifacts.require("AlbumArt");

module.exports = function (deployer) {
  deployer.deploy(ImageToken);
};
