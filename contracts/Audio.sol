pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Audio is Ownable, ERC721 {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  struct Metadata {
    string title;
    string composer;
    string genre;
    string url;
  }

  mapping(uint256 => Metadata) id_to_audio;

  string private _currentBaseURI;

  constructor() ERC721("Audio", "AUDIO") {
    setBaseURI("http://localhost/token/");

    mint("Test file", "Abhigya", "test", "https://soundcloud.com/yourparadis/sets/its-rainy-day?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing");

  }
  function setBaseURI(string memory baseURI) public onlyOwner {
      _currentBaseURI = baseURI;
  }

  function _baseURI() internal view virtual override returns (string memory) {
      return _currentBaseURI;
  }

  function mint(string memory title, string memory composer, string memory genre, string memory url) internal {
    _tokenIds.increment();
    uint256 tokenId = _tokenIds.current();

    id_to_audio[tokenId] = Metadata(title, composer, genre, url);
    _safeMint(msg.sender, tokenId);
  }

  function claim(string memory title, string memory composer, string memory genre, string memory url) external payable {
    require(msg.value == 0.01 ether, "claiming a data costs 10 finney");

    mint(title, composer, genre, url);
    payable(owner()).transfer(0.01 ether);
  }

  function get(uint256 tokenId) external view returns (string memory title, string memory composer, string memory genre, string memory url) {
    require (_exists(tokenId), "token not minted");
    Metadata memory track = id_to_audio[tokenId];
    title = track.title;
    composer = track.composer;
    genre = track.genre;
    url = track.url;
  }
}
