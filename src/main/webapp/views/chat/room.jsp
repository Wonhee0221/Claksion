<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <title>Websocket Chat</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <link rel="stylesheet" href="<c:url value='/webjars/bootstrap/4.3.1/css/bootstrap.min.css'/>">
    <script>
        $(document).ready(function() {
            findAllRoom();
        });

        function findAllRoom() {
            $.ajax({
                url: '/chat/rooms',
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    const chatroomsElement = $('#chatrooms');
                    chatroomsElement.empty();
                    data.forEach(item => {
                        const li = $('<li></li>').text(item.name).addClass('list-group-item list-group-item-action').click(function() {
                            enterRoom(item.roomId);
                        });
                        chatroomsElement.append(li);
                    });
                },
                error: function(error) {
                    console.error('Error fetching chat rooms:', error);
                }
            });
        }
        function createRoom() {
            const roomName = $('#room_name').val();
            if(roomName === "") {
                alert("방 제목을 입력해 주십시오.");
                return;
            }
            $.ajax({
                url: '/chat/room2',
                type: 'POST',
                data: {name: roomName},
                dataType: 'json',
                success: function(data) {
                    alert(data.name + " 방 개설에 성공하였습니다.");
                    $('#room_name').val('');
                    findAllRoom();
                },
                error: function(error) {
                    alert("채팅방 개설에 실패하였습니다.");
                }
            });
        }

        function enterRoom(roomId) {
            const sender = prompt('대화명을 입력해 주세요.');
            if(sender !== "") {
                localStorage.setItem('wschat.sender', sender);
                localStorage.setItem('wschat.roomId', roomId);
                location.href="<c:url value="/chat/room/enter"/>?roomId="+roomId
            }
        }
    </script>
</head>
<body>
<div class="container" id="app">
    <div class="row">
        <div class="col-md-12">
            <h3>채팅방 리스트</h3>
        </div>
    </div>
    <div class="input-group">
        <div class="input-group-prepend">
            <label class="input-group-text">방제목</label>
        </div>
        <input type="text" class="form-control" id="room_name" onkeyup="if(event.keyCode === 13) createRoom();">
        <div class="input-group-append">
            <button class="btn btn-primary" type="button" onclick="createRoom()">채팅방 개설</button>
        </div>
    </div>
    <ul class="list-group" id="chatrooms">
        <!-- 채팅방 목록은 서버로부터 받아옴 -->
    </ul>
</div>


</body>
</html>
