// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "ds-test/test.sol";
import "./Hevm.sol";
import "../../CitizenNFT.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

/// @notice Since we deploy the smart contract from another smart contract and
/// the users are smart contracts as well, we need to implement a special function
/// so that they can receive ERC721. We inherent from a well-known library
contract User is ERC1155Holder, DSTest {
    CitizenNFT internal citizenNFT;

    constructor(CitizenNFT _citizenNFT) {
        citizenNFT = _citizenNFT;
    }

    function initialCitizenship() public {
        citizenNFT.initialCitizenship();
    }

    function onlineApplicationForCitizenship(
        uint256 _citizenshipCost,
        uint256 _tokenNumber
    ) public {
        citizenNFT.onlineApplicationForCitizenship{
            value: _citizenshipCost * _tokenNumber
        }(_tokenNumber);
    }

    function legislateCostOfEntry(uint256 _weiAmmount) public {
        citizenNFT.legislateCostOfEntry(_weiAmmount);
    }

    function buildHousing(uint256 _numberOfNewCitizens) public {
        citizenNFT.buildHousing(_numberOfNewCitizens);
    }

    function rewriteHistory(uint256 _maxFoundingCitizens) public {
        citizenNFT.rewriteHistory(_maxFoundingCitizens);
    }

    function raidTheCoffers() public {
        citizenNFT.raidTheCoffers();
    }

    function awardCitizenship(
        address[] memory _addresses,
        uint256[] memory _tokens,
        uint256 _tokenType
    ) public {
        citizenNFT.awardCitizenship(_addresses, _tokens, _tokenType);
    }

    function setTokenRoyalty(
        uint256 _tokenId,
        address _recipient,
        uint16 _bps
    ) public {
        citizenNFT.setTokenRoyalty(_tokenId, _recipient, _bps);
    }

    function changeURIs(string[] calldata _hashes, uint256[] calldata _tokenIds)
        public
    {
        citizenNFT.changeURIs(_hashes, _tokenIds);
    }

    receive() external payable {}
}

/// @notice Helper test contract that sets up the testing suite.

contract CitizenTest is DSTest, ERC1155Holder {
    Hevm internal constant hevm = Hevm(HEVM_ADDRESS);
    // contracts
    CitizenNFT internal citizenNFT;
    // users
    User internal alice;
    User internal bob;
    User internal odys;
    address defaultRoyaltyReceiver;
    // Internal Ids
    uint256 citizenNFTInternalId = 42;
    uint256 foundingCitizenNFTInternalId = 69;
    uint256 firstCitizenNFTInternalId = 7;

    function setUp() public virtual {
        defaultRoyaltyReceiver = address(this);
        citizenNFT = new CitizenNFT(defaultRoyaltyReceiver, 1000);
        bob = new User(citizenNFT);
        alice = new User(citizenNFT);
        odys = new User(citizenNFT);
        // give Alice the maximum default number of Citizen NFTs on the Open Sea shared storefront smart contract
        citizenNFT.transferOwnership(address(odys));
        odys.initialCitizenship();
        assertEq(citizenNFT.balanceOf(address(odys), 42), 10000);
        assertEq(address(odys), citizenNFT.owner());
    }
}
