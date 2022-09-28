import 'dart:io';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

final emulatorIP = '10.0.2.2:3000'; // 127.0.0.1
final simulatorIP = '127.0.0.1:3000';

final ip = Platform.isIOS ? simulatorIP : emulatorIP;
