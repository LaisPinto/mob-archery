import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:torch_light/torch_light.dart';

class TimerFeedbackService {
  final AudioPlayer _player = AudioPlayer();

  // Beeps gerados em memória — sem necessidade de arquivos de áudio
  final Uint8List _warningBeep = _buildWav(frequency: 880, durationMs: 150);
  final Uint8List _completionBeep = _buildWav(frequency: 660, durationMs: 500);

  // ── Acessibilidade ────────────────────────────────────────────────────

  Future<void> announce(String message) async {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  // ── Háptico (VIBE) ────────────────────────────────────────────────────

  Future<void> selection() => HapticFeedback.selectionClick();

  Future<void> vibeWarning() => HapticFeedback.mediumImpact();

  Future<void> vibeCompletion() => HapticFeedback.heavyImpact();

  // ── Som (SOUND) ───────────────────────────────────────────────────────

  Future<void> playWarningSound() async {
    try {
      await _player.play(BytesSource(_warningBeep));
    } catch (_) {}
  }

  Future<void> playCompletionSound() async {
    try {
      await _player.play(BytesSource(_completionBeep));
    } catch (_) {}
  }

  // ── Lanterna (FLASH) ──────────────────────────────────────────────────

  /// Pisca a lanterna uma vez (~300 ms).
  Future<void> flash() async {
    try {
      final hasSupport = await TorchLight.isTorchAvailable();
      if (!hasSupport) return;
      await TorchLight.enableTorch();
      await Future.delayed(const Duration(milliseconds: 300));
      await TorchLight.disableTorch();
    } catch (_) {}
  }

  /// Pisca 3 vezes rapidamente (sinal de fim de série).
  Future<void> flashCompletion() async {
    try {
      final hasSupport = await TorchLight.isTorchAvailable();
      if (!hasSupport) return;
      for (int i = 0; i < 3; i++) {
        await TorchLight.enableTorch();
        await Future.delayed(const Duration(milliseconds: 200));
        await TorchLight.disableTorch();
        if (i < 2) await Future.delayed(const Duration(milliseconds: 150));
      }
    } catch (_) {}
  }

  // ── Ciclo de vida ─────────────────────────────────────────────────────

  void dispose() {
    _player.dispose();
  }

  // ── Geração de WAV em memória ─────────────────────────────────────────

  static Uint8List _buildWav({
    double frequency = 880.0,
    int durationMs = 200,
    int sampleRate = 44100,
  }) {
    final numSamples = (sampleRate * durationMs / 1000).round();
    final data = ByteData(44 + numSamples * 2);

    _writeStr(data, 0, 'RIFF');
    data.setUint32(4, 36 + numSamples * 2, Endian.little);
    _writeStr(data, 8, 'WAVE');
    _writeStr(data, 12, 'fmt ');
    data.setUint32(16, 16, Endian.little);
    data.setUint16(20, 1, Endian.little); // PCM
    data.setUint16(22, 1, Endian.little); // mono
    data.setUint32(24, sampleRate, Endian.little);
    data.setUint32(28, sampleRate * 2, Endian.little);
    data.setUint16(32, 2, Endian.little);
    data.setUint16(34, 16, Endian.little);
    _writeStr(data, 36, 'data');
    data.setUint32(40, numSamples * 2, Endian.little);

    final fadeLen = (numSamples * 0.05).round().clamp(1, numSamples);
    for (int i = 0; i < numSamples; i++) {
      final t = i / sampleRate;
      double amp = 0.7;
      if (i < fadeLen) amp *= i / fadeLen;
      if (i > numSamples - fadeLen) amp *= (numSamples - i) / fadeLen;
      final sample =
          (amp * 32767 * sin(2 * pi * frequency * t)).round().clamp(-32768, 32767);
      data.setInt16(44 + i * 2, sample, Endian.little);
    }

    return data.buffer.asUint8List();
  }

  static void _writeStr(ByteData data, int offset, String s) {
    for (int i = 0; i < s.length; i++) {
      data.setUint8(offset + i, s.codeUnitAt(i));
    }
  }
}