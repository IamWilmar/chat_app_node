import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat_app_node/models/user.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
   RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final users = [
    User(uid: '1', nombre: 'Wilmar', email: 'Wil@gmail.com', online: true),
    User(uid: '2', nombre: 'UserAnoni', email: 'Wil@gmail.com', online: false),
    User(uid: '3', nombre: 'Santiago', email: 'Wil@gmail.com', online: true),
    User(uid: '4', nombre: 'Nana', email: 'Wil@gmail.com', online: true),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User name', style: TextStyle(color: Colors.black54)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.blue),
          onPressed: () {},
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.blue[400]),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue[400],
        ),
        child: _ListViewUsuarios(users: users),
      ),
    );
  }

_cargarUsuarios() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
}

}

class _ListViewUsuarios extends StatelessWidget {
  const _ListViewUsuarios({
    Key key,
    @required this.users,
  }) : super(key: key);

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder:(_,i) => UserListTile(user: users[i]),
      itemCount: users.length,
      separatorBuilder: (_,i) => Divider(),
    );
  }
}

class UserListTile extends StatelessWidget {
  const UserListTile({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.nombre),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        backgroundColor: Colors.black,
        child: Text(user.nombre.substring(0,1)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: user.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
