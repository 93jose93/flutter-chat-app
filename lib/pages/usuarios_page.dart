import 'package:chat/models/usaurio.dart';
import 'package:chat/services/auth_services.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_services.dart';
import 'package:chat/services/usuarios_list_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsuariosPage extends StatefulWidget {



  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

   final usuariosListService = UsuariosListServices();

   RefreshController _refreshController = RefreshController(initialRefresh: false);
   
   List<Usuario> usuarios = [];

  /*
  final usuarios = [
    Usuario(online: true, email: 'ejemplo1@gmail.com', nombre: 'Alejandro', uid: '1'),
    Usuario(online: false, email: 'ejemplo2@gmail.com', nombre: 'Reina', uid: '2'),
    Usuario(online: true, email: 'ejemplo3@gmail.com', nombre: 'Andres', uid: '3'),  
  ];
  */
  @override
  void initState() {
    
    this._cargarUsuarios();


    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final authServices = Provider.of<AuthServices>(context);
    final socketServices = Provider.of<SocketServices>(context);
    //estraemos el nombre de usaurio
    final usuario = authServices.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text( usuario.nombre , style: TextStyle(color: Colors.black87),),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black87,),
          onPressed: () {
              //desconectarnos del soket server
              socketServices.disconnect();
              //para cerrar sesion   
              Navigator.pushReplacementNamed(context, 'login');
              //borra el token de sesion 
              AuthServices.deleteToken();
          },
        ),
        actions: <Widget>[
            Container(
               margin: EdgeInsets.only(right: 10),

               child: (socketServices.serverStatus == ServerStatus.Online)
               ? Icon(Icons.check_circle, color: Colors.blue[400],)
               : Icon(Icons.offline_bolt, color: Colors.red,)
            )
        ],
      ),
      //este SmartRefresher me permite recargar o refrescar la pagina actulizando
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        //aqui se pasa el metodo que va a refrescar
        //solo hay que pasar la referencia o me saldra este error
        //type 'Future<dynamic>' is not a subtype of type '(() => void)?'
        onRefresh: _cargarUsuarios,
        //este es el poll que se perzonaliza
        header: WaterDropHeader(
            complete: Icon(Icons.check, color: Colors.blue[400]),
            waterDropColor: Colors.blue,
        ),
        child: _listViewUsuarios(),
      )
   );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      //esto es parta ios
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioLisTitle(usuarios[i]),
      separatorBuilder: (_ , i) => Divider(),
      itemCount: usuarios.length
    );
  }

  ListTile _usuarioLisTitle(Usuario usuario) {
    return ListTile(
        title: Text(usuario.nombre),
        subtitle: Text( usuario.email),
        leading: CircleAvatar(
          child: Text(usuario.nombre.substring(0,2)),
          backgroundColor: Colors.blue[100]
        ), 
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online 
            ? Colors.green[300] 
            : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
        onTap: () {
          //usuarioPara es cuando soy el usuario conectado y le doy click a un usuario para escribir
          //print(usuario.nombre );

          //creamos la instancia
          final chatservices = Provider.of<ChatServices>(context, listen: false);

          //y lo enviamos al usuarioPara
          chatservices.usuarioPara = usuario;
          Navigator.pushNamed(context, 'chat');


        },
        
      );
  }

  _cargarUsuarios() async{
    
    this.usuarios = await usuariosListService.getUsuarios();
     
    setState(() {});
    // monitor network fetch
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  
  }
}