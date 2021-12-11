class ConnectionOpts {
  bool verbose;
  bool pedantic;
  bool tlsRequired;
  String authToken;
  String user;
  String pass;
  String name;
  String lang = "dart";
  String version;
  int protocol;
  bool echo;
  String sig;
  String jwt;

  ConnectionOpts(
      this.verbose,
      this.pedantic,
      this.tlsRequired,
      this.authToken,
      this.user,
      this.pass,
      this.name,
      this.version,
      this.protocol,
      this.echo,
      this.sig,
      this.jwt);

  Map<String, dynamic> toJson() => {
        "verbose": verbose,
        "pedantic": pedantic,
        "tls_required": tlsRequired,
        "auth_token": authToken,
        "user": user,
        "pass": pass,
        "name": name,
        "lang": lang,
        "version": version,
        "protocol": protocol,
        "echo": echo,
        "sig": sig,
        "jwt": jwt
      };
}
