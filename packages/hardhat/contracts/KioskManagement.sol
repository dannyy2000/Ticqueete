// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";




contract KioskManagement is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _kioskIdCounter;
    Counters.Counter private _ticketIdCounter;

    struct Kiosk {
        uint256 id;
        address owner;
        string location;
        uint256 spaceSize;
        uint256 pricePerYear;
        string image;
        bool isAvailable;
    }

    struct RentedKiosk {
        uint256 kioskId;
        uint256 startTime;
        uint256 endTime;
        uint256 ticketId;
    }

    mapping(uint256 => Kiosk) public kiosks;
    mapping(address => uint256[]) public ownerToKiosks;
    mapping(address => RentedKiosk[]) public renterToRentedKiosks;

    uint256[] public allKioskIds;

    event KioskCreated(uint256 indexed kioskId, address indexed owner);
    event KioskRented(
        uint256 indexed kioskId,
        address indexed renter,
        uint256 startTime,
        uint256 endTime,
        uint256 ticketId
    );

    constructor() ERC721("KioskTicket", "KST") {}

    // Create a kiosk
    function createKiosk(
        string memory _location,
        uint256 _spaceSize,
        uint256 _pricePerYear,
        string memory _image
    ) external {
        uint256 newKioskId = _kioskIdCounter.current();
        _kioskIdCounter.increment();

        kiosks[newKioskId] = Kiosk({
            id: newKioskId,
            owner: msg.sender,
            location: _location,
            spaceSize: _spaceSize,
            pricePerYear: _pricePerYear,
            image: _image,
            isAvailable: true
        });

        ownerToKiosks[msg.sender].push(newKioskId);
        allKioskIds.push(newKioskId);

        emit KioskCreated(newKioskId, msg.sender);
    }

    // View kiosks owned by the caller
    function viewOwnedKiosks() external view returns (uint256[] memory) {
        return ownerToKiosks[msg.sender];
    }

    // View all kiosks
    function viewAllKiosks() external view returns (uint256[] memory) {
        return allKioskIds;
    }

    // Search for kiosks by location, space size, and price
    function searchKiosks(
        string memory _location,
        uint256 _spaceSize,
        uint256 _maxPrice
    ) external view returns (uint256[] memory) {
        uint256[] memory result = new uint256[](allKioskIds.length);
        uint256 counter = 0;

        for (uint256 i = 0; i < allKioskIds.length; i++) {
            Kiosk memory kiosk = kiosks[allKioskIds[i]];
            if (
                kiosk.isAvailable &&
                (bytes(_location).length == 0 || keccak256(bytes(kiosk.location)) == keccak256(bytes(_location))) &&
                (_spaceSize == 0 || kiosk.spaceSize == _spaceSize) &&
                (_maxPrice == 0 || kiosk.pricePerYear <= _maxPrice)
            ) {
                result[counter] = kiosk.id;
                counter++;
            }
        }

        // Resize the array to fit the results
        uint256[] memory filteredResult = new uint256[](counter);
        for (uint256 j = 0; j < counter; j++) {
            filteredResult[j] = result[j];
        }

        return filteredResult;
    }

    // Rent a kiosk
    function rentKiosk(uint256 _kioskId, uint256 _rentalPeriodInDays) external payable {
        Kiosk storage kiosk = kiosks[_kioskId];
        require(kiosk.isAvailable, "Kiosk is not available");

        uint256 rentalCost = (kiosk.pricePerYear * _rentalPeriodInDays) / 365;
        require(msg.value >= rentalCost, "Insufficient payment");

        uint256 startTime = block.timestamp;
        uint256 endTime = block.timestamp + (_rentalPeriodInDays * 1 days);

        kiosk.isAvailable = false;
        uint256 newTicketId = _ticketIdCounter.current();
        _ticketIdCounter.increment();

        _mint(msg.sender, newTicketId);
        string memory ticketURI = string(abi.encodePacked("Kiosk Ticket #", toString(newTicketId)));
        _setTokenURI(newTicketId, ticketURI);

        renterToRentedKiosks[msg.sender].push(
            RentedKiosk({
                kioskId: _kioskId,
                startTime: startTime,
                endTime: endTime,
                ticketId: newTicketId
            })
        );

        emit KioskRented(_kioskId, msg.sender, startTime, endTime, newTicketId);

        // Transfer funds to the kiosk owner
        payable(kiosk.owner).transfer(msg.value);
    }

    // View rented kiosks by the caller
    function viewRentedKiosks() external view returns (RentedKiosk[] memory) {
        return renterToRentedKiosks[msg.sender];
    }

    // Utility function to convert uint256 to string
    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}