import React, { useState, useEffect } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ActivityIndicator,
  TouchableOpacity,
  Alert,
  SafeAreaView,
  StatusBar,
} from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';

// Nota: Para VNC nativo, usaremos WebSocket + Canvas
// Esta es una implementación que funciona con noVNC del servidor

export default function App() {
  const [connected, setConnected] = useState(false);
  const [loading, setLoading] = useState(true);
  const [serverUrl, setServerUrl] = useState('');
  const [connectionError, setConnectionError] = useState(null);

  // Configuración del servidor
  const SERVER_HOST = 'flashbrowser-xyz.onrender.com'; // Cambiar en producción
  const SERVER_PORT = 5901;
  const SERVER_PASSWORD = '123456';
  const NOVNC_WEB_PORT = 6080; // Para acceso web

  useEffect(() => {
    initializeConnection();
  }, []);

  const initializeConnection = async () => {
    try {
      setLoading(true);
      setConnectionError(null);

      // Cargar configuración guardada
      const savedUrl = await AsyncStorage.getItem('server_url');
      const url = savedUrl || `http://${SERVER_HOST}:${NOVNC_WEB_PORT}`;
      
      setServerUrl(url);

      // Intentar conectar automáticamente
      await connectToServer(url);
    } catch (error) {
      console.error('Error inicializando conexión:', error);
      setConnectionError('Error al conectar. Verifica tu conexión.');
      setLoading(false);
    }
  };

  const connectToServer = async (url) => {
    try {
      // Verificar que el servidor esté disponible
      const response = await fetch(`${url}`, {
        method: 'HEAD',
        mode: 'no-cors',
      });

      // Si llegamos aquí, el servidor responde
      setConnected(true);
      setLoading(false);

      // Guardar URL para próximas conexiones
      await AsyncStorage.setItem('server_url', url);
    } catch (error) {
      console.error('No se pudo conectar al servidor:', error);
      setConnectionError(`No se puede conectar a ${SERVER_HOST}`);
      setLoading(false);
    }
  };

  const retryConnection = () => {
    initializeConnection();
  };

  const openVncInBrowser = () => {
    // Para experiencia completa, abre en navegador integrado
    const vncUrl = `http://${SERVER_HOST}:${NOVNC_WEB_PORT}/?path=?password=${SERVER_PASSWORD}&autoconnect=true`;
    
    Alert.alert(
      'Abriendo Juego',
      'Se abrirá el navegador con el juego en vivo',
      [
        { text: 'Cancelar', onPress: () => {} },
        { text: 'Abrir', onPress: () => {
          // En una app real, usarías react-native-webview o Linking
          console.log('Abriendo:', vncUrl);
        }},
      ]
    );
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <StatusBar barStyle="light-content" backgroundColor="#1a1a1a" />
        <View style={styles.centerContent}>
          <Text style={styles.appTitle}>Flash Game Server</Text>
          <ActivityIndicator size="large" color="#4CAF50" style={styles.loader} />
          <Text style={styles.loadingText}>Conectando al servidor...</Text>
          <Text style={styles.serverText}>
            {serverUrl || `${SERVER_HOST}:${NOVNC_WEB_PORT}`}
          </Text>
        </View>
      </SafeAreaView>
    );
  }

  if (connectionError) {
    return (
      <SafeAreaView style={styles.container}>
        <StatusBar barStyle="light-content" backgroundColor="#1a1a1a" />
        <View style={styles.centerContent}>
          <Text style={styles.appTitle}>Flash Game Server</Text>
          <View style={styles.errorBox}>
            <Text style={styles.errorIcon}>⚠️</Text>
            <Text style={styles.errorText}>{connectionError}</Text>
            <Text style={styles.errorDetail}>
              Verifica que el servidor esté activo y tu conexión a internet funcione.
            </Text>
          </View>
          <TouchableOpacity style={styles.retryButton} onPress={retryConnection}>
            <Text style={styles.retryButtonText}>Reintentar</Text>
          </TouchableOpacity>
          <TouchableOpacity 
            style={[styles.retryButton, styles.altButton]} 
            onPress={() => {
              Alert.prompt(
                'Servidor Personalizado',
                'Ingresa la URL del servidor:',
                [
                  { text: 'Cancelar', onPress: () => {} },
                  { 
                    text: 'Conectar', 
                    onPress: (url) => connectToServer(url)
                  },
                ],
                'plain-text',
                `http://${SERVER_HOST}:${NOVNC_WEB_PORT}`
              );
            }}
          >
            <Text style={styles.retryButtonText}>Servidor Personalizado</Text>
          </TouchableOpacity>
        </View>
      </SafeAreaView>
    );
  }

  // Conectado exitosamente
  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="light-content" backgroundColor="#1a1a1a" />
      
      <View style={styles.header}>
        <Text style={styles.appTitle}>Flash Game Server</Text>
        <Text style={styles.statusBadge}>🟢 Conectado</Text>
      </View>

      <View style={styles.content}>
        <Text style={styles.welcomeText}>¡Listo para jugar!</Text>
        
        <View style={styles.infoBox}>
          <Text style={styles.infoTitle}>Servidor Activo</Text>
          <Text style={styles.infoText}>{serverUrl}</Text>
        </View>

        <View style={styles.featuresList}>
          <View style={styles.featureItem}>
            <Text style={styles.featureIcon}>🎮</Text>
            <Text style={styles.featureText}>Juego en vivo desde servidor Linux</Text>
          </View>
          <View style={styles.featureItem}>
            <Text style={styles.featureIcon}>⚡</Text>
            <Text style={styles.featureText}>Conexión de baja latencia</Text>
          </View>
          <View style={styles.featureItem}>
            <Text style={styles.featureIcon}>🔒</Text>
            <Text style={styles.featureText}>Contraseña protegida</Text>
          </View>
          <View style={styles.featureItem}>
            <Text style={styles.featureIcon}>📱</Text>
            <Text style={styles.featureText}>Control total desde Android</Text>
          </View>
        </View>
      </View>

      <View style={styles.buttonContainer}>
        <TouchableOpacity 
          style={styles.playButton}
          onPress={openVncInBrowser}
        >
          <Text style={styles.playButtonText}>🎮 JUGAR AHORA</Text>
        </TouchableOpacity>

        <TouchableOpacity 
          style={styles.settingsButton}
          onPress={() => {
            Alert.alert(
              'Configuración',
              'Servidor configurado correctamente',
              [
                { text: 'Desconectar', onPress: () => {
                  setConnected(false);
                  initializeConnection();
                }},
                { text: 'Cerrar', onPress: () => {} },
              ]
            );
          }}
        >
          <Text style={styles.settingsButtonText}>⚙️ Configuración</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.footer}>
        <Text style={styles.footerText}>v1.0.0</Text>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#1a1a1a',
  },
  header: {
    paddingHorizontal: 20,
    paddingVertical: 15,
    borderBottomWidth: 1,
    borderBottomColor: '#333',
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  appTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#fff',
  },
  statusBadge: {
    fontSize: 14,
    backgroundColor: '#4CAF50',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 12,
    color: '#fff',
  },
  centerContent: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 20,
  },
  loader: {
    marginVertical: 20,
  },
  loadingText: {
    fontSize: 16,
    color: '#aaa',
    marginTop: 10,
    textAlign: 'center',
  },
  serverText: {
    fontSize: 12,
    color: '#666',
    marginTop: 5,
    textAlign: 'center',
  },
  errorBox: {
    backgroundColor: '#2a1a1a',
    borderRadius: 12,
    padding: 20,
    marginVertical: 20,
    borderLeftWidth: 4,
    borderLeftColor: '#ff6b6b',
  },
  errorIcon: {
    fontSize: 40,
    textAlign: 'center',
    marginBottom: 10,
  },
  errorText: {
    fontSize: 16,
    color: '#ff6b6b',
    fontWeight: 'bold',
    marginBottom: 10,
    textAlign: 'center',
  },
  errorDetail: {
    fontSize: 12,
    color: '#aaa',
    textAlign: 'center',
  },
  content: {
    flex: 1,
    paddingHorizontal: 20,
    paddingVertical: 20,
  },
  welcomeText: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#fff',
    marginBottom: 20,
    textAlign: 'center',
  },
  infoBox: {
    backgroundColor: '#2a2a2a',
    borderRadius: 12,
    padding: 15,
    marginBottom: 20,
    borderLeftWidth: 4,
    borderLeftColor: '#4CAF50',
  },
  infoTitle: {
    fontSize: 12,
    color: '#aaa',
    marginBottom: 5,
    fontWeight: '600',
  },
  infoText: {
    fontSize: 14,
    color: '#4CAF50',
    fontWeight: 'bold',
  },
  featuresList: {
    marginTop: 10,
  },
  featureItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: '#2a2a2a',
  },
  featureIcon: {
    fontSize: 20,
    marginRight: 12,
  },
  featureText: {
    fontSize: 14,
    color: '#aaa',
    flex: 1,
  },
  buttonContainer: {
    paddingHorizontal: 20,
    paddingBottom: 20,
    gap: 12,
  },
  playButton: {
    backgroundColor: '#4CAF50',
    borderRadius: 12,
    paddingVertical: 16,
    alignItems: 'center',
    shadowColor: '#4CAF50',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    elevation: 8,
  },
  playButtonText: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#fff',
  },
  settingsButton: {
    backgroundColor: '#333',
    borderRadius: 12,
    paddingVertical: 14,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#444',
  },
  settingsButtonText: {
    fontSize: 16,
    color: '#aaa',
    fontWeight: '600',
  },
  retryButton: {
    backgroundColor: '#4CAF50',
    borderRadius: 12,
    paddingVertical: 14,
    paddingHorizontal: 40,
    marginTop: 15,
    alignItems: 'center',
  },
  altButton: {
    backgroundColor: '#333',
    borderWidth: 1,
    borderColor: '#4CAF50',
  },
  retryButtonText: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#fff',
  },
  footer: {
    paddingVertical: 15,
    alignItems: 'center',
    borderTopWidth: 1,
    borderTopColor: '#333',
  },
  footerText: {
    fontSize: 12,
    color: '#666',
  },
});
