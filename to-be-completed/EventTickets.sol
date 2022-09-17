// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

    /*
        The EventTickets contract keeps track of the details and ticket sales of one event.
     */

contract EventTickets {

    /*
        Create a public state variable called owner.
        Use the appropriate keyword to create an associated getter function.
        Use the appropriate keyword to allow ether transfers.
     */

    address payable public owner;
    uint   TICKET_PRICE = 100 wei;

    /*
        Create a struct called "Event".
        The struct has 6 fields: description, website (URL), totalTickets, sales, buyers, and isOpen.
        Choose the appropriate variable type for each field.
        The "buyers" field should keep track of addresses and how many tickets each buyer purchases.
    */

    struct Event {
        string description;
        string website;
        uint256 totalTickets;
        uint256 sales;
        mapping(address => uint256) buyers;
        bool isOpen;
    }

    Event public ev;
   
    /*
        Define 3 logging events.
        LogBuyTickets should provide information about the purchaser and the number of tickets purchased.
        LogGetRefund should provide information about the refund requester and the number of tickets refunded.
        LogEndSale should provide infromation about the contract owner and the balance transferred to them.
    */
    
    event LogBuyTickets(address purchaser, uint256 numberOfTickets);
    event LogGetRefund(address refundRequester, uint256 numberOfTickets);
    event LogEndSale(address owner, uint256 balance);

    /*
        Create a modifier that throws an error if the msg.sender is not the owner.
    */
    modifier isOwner() {
        require(msg.sender == owner, "Not an owner");
        _;
    }
    

    /*
        Define a constructor.
        The constructor takes 3 arguments, the description, the URL and the number of tickets for sale.
        Set the owner to the creator of the contract.
        Set the appropriate myEvent details.
    */

    constructor(
        string memory description,
        string memory url,
        uint256 numberOfTickets
    ) {
        owner = payable(msg.sender);
        ev.description = description;
        ev.website = url;
        ev.totalTickets = numberOfTickets;
        ev.isOpen = true;
    }

    /*
        Define a function called readEvent() that returns the event details.
        This function does not modify state, add the appropriate keyword.
        The returned details should be called description, website, uint totalTickets, uint sales, bool isOpen in that order.
    */
    function readEvent()
        public
        view
        returns(string memory description, string memory website, uint totalTickets, uint sales, bool isOpen)
    {
        return (ev.description, ev.website, ev.totalTickets, ev.sales, ev.isOpen);
    }

    /*
        Define a function called getBuyerTicketCount().
        This function takes 1 argument, an address and
        returns the number of tickets that address has purchased.
    */

    function getBuyerTicketCount(address buyer_) public view returns (uint256) {
        return ev.buyers[buyer_];
    }

    /*
        Define a function called buyTickets().
        This function allows someone to purchase tickets for the event.
        This function takes one argument, the number of tickets to be purchased.
        This function can accept Ether.
        Be sure to check:
            - That the event isOpen
            - That the transaction value is sufficient for the number of tickets purchased
            - That there are enough tickets in stock
        Then:
            - add the appropriate number of tickets to the purchasers count
            - account for the purchase in the remaining number of available tickets
            - refund any surplus value sent with the transaction
            - emit the appropriate event
    */

    function buyTickets(uint256 numberOfTickets_) 
        public 
        payable
    {
        require(ev.isOpen = true, "Event not open yet");
        require(msg.value >= numberOfTickets_ * TICKET_PRICE);
        require(ev.totalTickets - ev.sales > numberOfTickets_);

        ev.buyers[msg.sender] += numberOfTickets_;
        ev.sales += numberOfTickets_;

        if (msg.value > numberOfTickets_ * TICKET_PRICE) {
            payable(msg.sender).transfer( (msg.value) - (numberOfTickets_ * TICKET_PRICE) );
        }

        emit LogBuyTickets(msg.sender, numberOfTickets_);
    }

    /*
        Define a function called getRefund().
        This function allows someone to get a refund for tickets for the account they purchased from.
        TODO:
            - Check that the requester has purchased tickets.
            - Make sure the refunded tickets go back into the pool of avialable tickets.
            - Transfer the appropriate amount to the refund requester.
            - Emit the appropriate event.
    */
    function getRefund() public {
        uint256 numberOfTickets = ev.buyers[msg.sender];
        require(numberOfTickets > 0, "You have not purchased any tickets.");
        ev.sales -= numberOfTickets;
        payable(msg.sender).transfer(numberOfTickets * TICKET_PRICE);

        emit LogGetRefund(msg.sender, numberOfTickets);
    }

    /*
        Define a function called endSale().
        This function will close the ticket sales.
        This function can only be called by the contract owner.
        TODO:
            - close the event
            - transfer the contract balance to the owner
            - emit the appropriate event
    */
    function endSale() public isOwner {
        ev.isOpen = false;

        uint256 balance = address(this).balance;
        payable(msg.sender).transfer( balance );

        emit LogEndSale(msg.sender, balance);
    }
}
