// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract Twitter{
 struct Tweet{
   uint id;
   address author;
   string content;
   uint createdAt;
 }
 struct message{
   uint id;
   string content;
   address from;
   address to;
   uint createdAt;
 }
  mapping(uint=>Tweet)public tweets; //
  mapping(address=>uint[])public tweetsof;
  mapping(address=>message[])public conversations;
  mapping(address=>mapping(address=>bool))public operators;
  mapping(address=>address[])public following;
  uint nextId;
  uint nextMessageId; 


function tweet(address _from,string memory _content )internal{ //this functon will tweet 
  tweets[nextId]=Tweet(nextId,_from,_content,block.timestamp);
  nextId=nextId+1;
}
function sendMessage(string memory _content,address _from,address _to)internal{  //this function will send messages 
  conversations[_from].push(message(nextMessageId,_content,_from,_to,block.timestamp));
    nextMessageId++;
}
function _tweet(string memory _content) public {
  tweet(msg.sender,_content);
}
function _tweet(address from,string memory _content)public{
   tweet(from,_content);
}
function _sendMessage(string memory _content,address _to)public{
  sendMessage(_content,msg.sender, _to);
}
function _sendMessage(string memory _content,address _from,address _to)public{
  sendMessage(_content,_from,_to);
}
function follow(address followed)public{
  following[msg.sender].push(followed);
}
function allow(address _operators)public{
  operators[msg.sender][_operators]=true;
}
function disallow(address _operators)public{
  operators[msg.sender][_operators]=false;
}
function getLatestTweets(uint count)public view returns(Tweet[]memory){
  require(count>0 && count<nextId,"count is not proper");
  Tweet[] memory _tweets=new Tweet[](count);
  uint j;
  for(uint i=nextId-count;i<nextId;i++){
    Tweet storage _structure=tweets[i];
    _tweets[j]=Tweet(_structure.id,_structure.author,_structure.content,_structure.createdAt);
    j=j+1;
  }
  return _tweets;
  
}
function getLatestofUser(address _user,uint count)public view returns(Tweet[]memory){
  Tweet[]memory _tweets=new Tweet[](count);
  uint[]memory ids=tweetsof[_user];
  require(count>0 && count<=ids.length,"Count is not defined");
  uint j;
  for(uint i=ids.length-count;i<ids.length;i++){
    Tweet storage _structure=tweets[ids[i]];
    _tweets[j]=Tweet(_structure.id,_structure.author,_structure.content,_structure.createdAt);
    j=j+1;
  }
   return _tweets;
}
}
