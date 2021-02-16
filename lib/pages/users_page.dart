import 'package:chat_app_node/services/chat_service.dart';
import 'package:chat_app_node/services/socket_service.dart';
import 'package:chat_app_node/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat_app_node/models/user.dart';
import 'package:chat_app_node/services/auth_service.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final usuariosService = new UsuariosService();
  List<Usuario> usuarios = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
     this._cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(authService.usuario.nombre,
            style: TextStyle(color: Colors.black54)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.blue),
          onPressed: () {
            //Desconectarnos de socket server
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online
                ? Icon(Icons.check_circle, color: Colors.blue[400])
                : Icon(Icons.offline_bolt, color: Colors.red),
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
        child: _ListViewUsuarios(users: usuarios),
      ),
    );
  }

  _cargarUsuarios() async {
    this.usuarios = await usuariosService.getUsuario();
    // monitor network fetch
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    setState(() {});
    _refreshController.refreshCompleted();
  }
}

class _ListViewUsuarios extends StatelessWidget {
  const _ListViewUsuarios({
    Key key,
    @required this.users,
  }) : super(key: key);

  final List<Usuario> users;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => UserListTile(user: users[i]),
      itemCount: users.length,
      separatorBuilder: (_, i) => Divider(),
    );
  }
}

class UserListTile extends StatelessWidget {
  const UserListTile({
    Key key,
    @required this.user,
  }) : super(key: key);

  final Usuario user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.nombre),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        backgroundColor: Colors.black,
        child: Text(user.nombre.substring(0, 1)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: user.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      onTap: (){
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }
}
