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
        "verbose": this.verbose,
        "pedantic": this.pedantic,
        "tls_required": this.tlsRequired,
        "auth_token": this.authToken,
        "user": this.user,
        "pass": this.pass,
        "name": this.name,
        "lang": this.lang,
        "version": this.version,
        "protocol": this.protocol,
        "echo": this.echo,
        "sig": this.sig,
        "jwt": this.jwt
      };
}
