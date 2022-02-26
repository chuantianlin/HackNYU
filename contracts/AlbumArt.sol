pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract AlbumArt is Ownable, ERC721 {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  struct Metadata {
    string title;
    string artist;
    string genre;
    string url;
  }

  mapping(uint256 => Metadata) id_to_image;

  string private _currentBaseURI;

  constructor() ERC721("Audio", "AUDIO") {
    setBaseURI("http://localhost/token/");

    mint("Test file", "Abhigya", "test", "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg");

  }
  function setBaseURI(string memory baseURI) public onlyartist {
      _currentBaseURI = baseURI;
  }

  function _baseURI() internal view virtual override returns (string memory) {
      return _currentBaseURI;
  }

  function mint(string memory title, string memory artist, string memory genre, string memory url) internal {
    _tokenIds.increment();
    uint256 tokenId = _tokenIds.current();

    id_to_image[tokenId] = Metadata(title, artist, genre, url);
    _safeMint(msg.sender, tokenId);
  }

  function claim(string memory title, string memory artist, string memory genre, string memory url) external payable {
    require(msg.value == 0.01 ether, "claiming a data costs 10 finney");

    mint(title, artist, genre, url);
    payable(artist()).transfer(0.01 ether);
  }

  function get(uint256 tokenId) external view returns (string memory title, string memory artist, string memory genre, string memory url) {
    require (_exists(tokenId), "token not minted");
    Metadata memory track = id_to_image[tokenId];
    title = track.title;
    artist = track.artist;
    genre = track.genre;
    url = track.url;
  }
}
