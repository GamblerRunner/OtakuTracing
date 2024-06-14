import 'package:flutter/material.dart';

void main() {
  runApp(HelpApp());
}

class HelpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HelpPage(),
    );
  }
}

class HelpPage extends StatelessWidget {
  final String termsAndConditions = '''
Términos y Condiciones de Uso - OtrakuTracing

Bienvenido a OtrakuTracing. Estos términos y condiciones rigen el acceso y uso de la aplicación móvil OtrakuTracing y todos los servicios relacionados proporcionados por OtakuTracing.

**1. Aceptación de los Términos**

Al acceder o utilizar la Aplicación, aceptas estar sujeto a estos Términos y nuestra Política de Privacidad. Si no estás de acuerdo con alguno de estos términos, no utilices la Aplicación.

**2. Uso de la Aplicación**

2.1. **Acceso y Disponibilidad**: Te comprometes a acceder y utilizar la Aplicación únicamente para fines legales y de acuerdo con estos Términos.

2.2. **Cuentas de Usuario**: Es posible que necesites registrarte para acceder a ciertas funciones de la Aplicación. Debes proporcionar información precisa y completa durante el proceso de registro y mantener la confidencialidad de tus credenciales de inicio de sesión.

2.3. **Contenido del Usuario**: Al utilizar la Aplicación, puedes proporcionar contenido como comentarios, imágenes o información personal. Eres responsable del contenido que compartas y garantizas que tienes los derechos necesarios para hacerlo.

**3. Propiedad Intelectual**

3.1. **Derechos de Autor**: Todos los derechos de propiedad intelectual en la Aplicación y su contenido son propiedad de [Nombre de la Empresa o Desarrollador] o sus licenciatarios.

3.2. **Licencia Limitada**: Se te concede una licencia limitada, no exclusiva y no transferible para utilizar la Aplicación de acuerdo con estos Términos.

**4. Limitación de Responsabilidad**

4.1. **Uso Bajo Tu Propio Riesgo**: La Aplicación se proporciona "tal cual" y "según disponibilidad". [Nombre de la Empresa o Desarrollador] no ofrece garantías explícitas o implícitas sobre la exactitud, fiabilidad o disponibilidad de la Aplicación.

4.2. **Limitación de Responsabilidad**: En la medida máxima permitida por la ley aplicable, [Nombre de la Empresa o Desarrollador] no será responsable por ningún daño directo, indirecto, incidental, especial o consecuente que surja del uso de la Aplicación.

**5. Modificaciones de los Términos**

Nos reservamos el derecho de actualizar o modificar estos Términos en cualquier momento. Te notificaremos sobre cambios significativos a través de la Aplicación. El uso continuado de la Aplicación después de dichas modificaciones constituirá tu consentimiento a los cambios.

**6. Disposiciones Generales**

6.1. **Ley Aplicable**: Estos Términos se regirán e interpretarán de acuerdo con las leyes del [país o estado] sin tener en cuenta sus conflictos de principios legales.

6.2. **Divisibilidad**: Si alguna disposición de estos Términos se considera inválida o inaplicable, dicha disposición será interpretada en la medida máxima posible y el resto de los Términos permanecerán en pleno vigor y efecto.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TERMINOS Y CONDICIONES\n                 DE USO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          termsAndConditions,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
