// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _en_US = {
  "modules": {
    "auth": {
      "login": {
        "title": "Welcome back",
        "subtitle": "Sign in to keep your training focused and competition-ready.",
        "email_label": "Email",
        "password_label": "Password",
        "button": "Sign in"
      },
      "register": {
        "title": "Create your account",
        "subtitle": "Set up your athlete profile and sync your training history.",
        "name_label": "Name",
        "confirm_password_label": "Confirm password",
        "button": "Create account",
        "back_to_login": "Back to sign in",
        "password_hint": "Use at least 8 characters with letters and numbers",
        "terms_label": "I accept the Terms of Use and Privacy Policy.",
        "create_button": "Create my account"
      },
      "forgot_password": {
        "title": "Recover password",
        "message": "Enter your email and we will send a reset link.",
        "button": "Forgot password?",
        "send_reset_button": "Send reset email",
        "page_title": "Forgot your password?",
        "description": "Don't worry, it happens to the best archers. Enter your email below and we'll send you instructions to reset your password.",
        "email_section_label": "REGISTERED EMAIL",
        "send_link_button": "Send Recovery Link"
      },
      "verification": {
        "title": "Verify your email",
        "message": "Check your inbox and confirm your email before entering the app.",
        "resend_button": "Resend verification email",
        "check_button": "I already verified my email",
        "sent_message": "We sent a verification link to your registered email address. Please check your inbox.",
        "back_to_login": "Back to login",
        "not_received": "Didn't receive the email?",
        "resend_link": "Resend link"
      },
      "reset_password": {
        "title": "Reset password",
        "message": "Paste the action code from the email and set a new password.",
        "code_label": "Action code",
        "button": "Update password",
        "page_title": "New Password",
        "description": "Your new password must be unique to protect your archer account.",
        "strength_label": "Password strength",
        "submit_button": "RESET PASSWORD",
        "cancel_button": "Cancel and return to login"
      },
      "logout_button": "Sign out"
    },
    "home": {
      "dashboard": {
        "title": "Dashboard",
        "greeting": "Good training, {}",
        "greeting_fallback": "archer",
        "subtitle": "Quick access to timer, scoring and accessibility settings.",
        "coming_soon": "COMING SOON",
        "weekly_progress": "Weekly Progress",
        "see_all": "See all",
        "welcome_back": "Welcome back",
        "day_status": "DAY STATUS",
        "quick_access": "Quick Access"
      },
      "summary": {
        "sessions": "Sessions",
        "arrows": "Arrows",
        "average": "Average",
        "x_count": "X count"
      },
      "shortcuts": {
        "timer": {
          "title": "Competition timer",
          "subtitle": "Configure countdown rules for 3 or 6 arrows."
        },
        "register_end": {
          "title": "Register end",
          "subtitle": "Capture arrows and metrics directly from the shooting line."
        },
        "spotter": {
          "title": "Spotter mode",
          "subtitle": "Let another person register your end with accessible flow."
        },
        "history": {
          "title": "Training history",
          "subtitle": "Review sessions, averages, X count and ten count."
        },
        "accessibility": {
          "title": "Accessibility",
          "subtitle": "Adjust contrast, timer assistance and multimodal feedback."
        },
        "profile": {
          "title": "Profile",
          "subtitle": "Update your athlete identity, language and unit preferences."
        }
      }
    },
    "timer": {
      "main": {
        "title": "Timer",
        "config_button": "Configure",
        "countdown_label": "Remaining time",
        "arrows_label": "Arrows",
        "mode_label": "Mode",
        "start": "Start",
        "pause": "Pause",
        "reset": "Reset",
        "next_end": "Next End"
      },
      "modes": {
        "competition": "Competition rules",
        "per_arrow": "30 seconds per arrow"
      },
      "accessibility": {
        "title": "Accessible timer",
        "description": "Adds 10 extra seconds for each arrow.",
        "enabled": "Enabled",
        "disabled": "Disabled"
      },
      "config": {
        "title": "Timer settings",
        "apply_button": "Apply settings",
        "total_duration": "Total duration",
        "page_title": "Configure Timer",
        "total_arrows_label": "TOTAL ARROWS",
        "series_per_round": "Series per Round",
        "arrows_per_series": "Arrows per Series",
        "alternate_shooters": "Alternate Shooters (AB/CD)",
        "alternate_shooters_desc": "Automatic switch between pairs",
        "time_presets": "Time Presets",
        "start_button": "START TIMER"
      }
    },
    "training": {
      "register": {
        "title": "Register end",
        "distance": "Distance",
        "bow_type": "Bow type",
        "spotter_name": "Spotter name",
        "by_user": "Athlete",
        "by_spotter": "Spotter",
        "save_button": "Save end",
        "selected_scores": "SELECTED SCORES",
        "edit_context": "Edit context",
        "spotter_toggle_title": "Spotter Entry",
        "spotter_toggle_desc": "Check if another person is scoring"
      },
      "spotter_mode": {
        "title": "Spotter mode",
        "description": "Use this screen when someone else is recording the end for the athlete.",
        "start_button": "Start spotter entry",
        "page_title": "Spotter Registration",
        "info_title": "Registration Info",
        "info_subtitle": "Confirm the details of the assisted operation",
        "active_label": "Spotter assistance is active",
        "responsible_name": "Responsible Spotter Name",
        "finish_button": "Finish Registration"
      },
      "history": {
        "title": "Training history",
        "empty": "No training sessions found yet.",
        "summary_label": "{} arrows • average {}"
      },
      "details": {
        "title": "Training detail",
        "average": "Average",
        "total_arrows": "Total arrows",
        "x_count": "X count",
        "ten_count": "Ten count",
        "ends": "Ends",
        "end_summary": "Average {} • {} m • {}"
      }
    },
    "accessibility": {
      "title": "Accessibility",
      "high_contrast": {
        "label": "High contrast theme",
        "description": "Increase color contrast and visual separation."
      },
      "timer_mode": {
        "label": "Accessible timer mode",
        "description": "Adds extra time to each arrow according to the rules."
      },
      "announcements": {
        "title": "Screen reader announcements",
        "subtitle": "Announce important changes like timer completion."
      },
      "haptic": {
        "title": "Haptic feedback",
        "subtitle": "Support time-critical actions with vibration feedback."
      },
      "personalize_title": "Personalize the app for your comfort.",
      "personalize_subtitle": "All actions have visible buttons and extended touch areas.",
      "text_size_label": "Text size",
      "text_size_hint": "Adjust size for dynamic reading (Dynamic Type)",
      "section_visual": "VISUAL & INTERACTION",
      "section_alerts": "ALERT SIGNALS",
      "section_reaction": "REACTION TIME"
    },
    "profile": {
      "title": "Profile",
      "errors": {
        "no_user": "No user profile available.",
        "not_found": "No profile found"
      },
      "fields": {
        "name": {
          "label": "Name",
          "subtitle": "This name is shown in your athlete profile."
        },
        "email": {
          "label": "Email",
          "subtitle": "Your sign-in email comes from Firebase Authentication."
        },
        "language": {
          "label": "Preferred language",
          "subtitle": "Choose the app language for navigation and scoring screens.",
          "options": {
            "en": "English (US)",
            "pt": "Portuguese (Brazil)",
            "es": "Spanish (Spain)"
          }
        },
        "units": {
          "label": "Distance unit",
          "subtitle": "Define how field distances are represented.",
          "meters": "Meters",
          "yards": "Yards"
        }
      },
      "save_button": "Save profile",
      "level_label": "Level: Intermediate Archer",
      "app_settings_section": "APP SETTINGS",
      "save_changes_button": "Save changes",
      "sign_out_button": "Sign out"
    }
  }
};
static const Map<String,dynamic> _es_ES = {
  "modules": {
    "auth": {
      "login": {
        "title": "Bienvenido de nuevo",
        "subtitle": "Inicia sesión para mantener tu entrenamiento enfocado y listo para competir.",
        "email_label": "Correo electrónico",
        "password_label": "Contraseña",
        "button": "Iniciar sesión"
      },
      "register": {
        "title": "Crea tu cuenta",
        "subtitle": "Configura tu perfil de atleta y sincroniza tu historial de entrenamiento.",
        "name_label": "Nombre",
        "confirm_password_label": "Confirmar contraseña",
        "button": "Crear cuenta",
        "back_to_login": "Volver a iniciar sesión",
        "password_hint": "Usa al menos 8 caracteres con letras y números",
        "terms_label": "Acepto los Términos de uso y la Política de privacidad.",
        "create_button": "Crear mi cuenta"
      },
      "forgot_password": {
        "title": "Recuperar contraseña",
        "message": "Introduce tu correo y enviaremos un enlace de restablecimiento.",
        "button": "¿Olvidaste tu contraseña?",
        "send_reset_button": "Enviar correo de restablecimiento",
        "page_title": "¿Olvidaste tu contraseña?",
        "description": "No te preocupes, le pasa a los mejores arqueros. Introduce tu correo a continuación y te enviaremos instrucciones para restablecer tu contraseña.",
        "email_section_label": "CORREO REGISTRADO",
        "send_link_button": "Enviar enlace de recuperación"
      },
      "verification": {
        "title": "Verifica tu correo",
        "message": "Confirma tu correo antes de entrar en la aplicación.",
        "resend_button": "Reenviar correo de verificación",
        "check_button": "Ya verifiqué mi correo",
        "sent_message": "Enviamos un enlace de verificación a tu dirección de correo electrónico registrada. Por favor, revisa tu bandeja de entrada.",
        "back_to_login": "Volver al inicio de sesión",
        "not_received": "¿No recibiste el correo?",
        "resend_link": "Reenviar enlace"
      },
      "reset_password": {
        "title": "Restablecer contraseña",
        "message": "Pega el código recibido por correo y define una nueva contraseña.",
        "code_label": "Código de acción",
        "button": "Actualizar contraseña",
        "page_title": "Nueva contraseña",
        "description": "Tu nueva contraseña debe ser única para proteger tu cuenta de arquero.",
        "strength_label": "Fuerza de la contraseña",
        "submit_button": "RESTABLECER CONTRASEÑA",
        "cancel_button": "Cancelar y volver al inicio de sesión"
      },
      "logout_button": "Cerrar sesión"
    },
    "home": {
      "dashboard": {
        "title": "Panel",
        "greeting": "Buen entrenamiento, {}",
        "greeting_fallback": "arquero",
        "subtitle": "Acceso rápido al temporizador, registro de puntuación y accesibilidad.",
        "coming_soon": "PRÓXIMAMENTE",
        "weekly_progress": "Progreso semanal",
        "see_all": "Ver todo",
        "welcome_back": "Bienvenida de nuevo",
        "day_status": "ESTADO DEL DÍA",
        "quick_access": "Acceso rápido"
      },
      "summary": {
        "sessions": "Sesiones",
        "arrows": "Flechas",
        "average": "Promedio",
        "x_count": "Conteo de X"
      },
      "shortcuts": {
        "timer": {
          "title": "Temporizador de competición",
          "subtitle": "Configura la cuenta regresiva para 3 o 6 flechas."
        },
        "register_end": {
          "title": "Registrar end",
          "subtitle": "Captura flechas y métricas directamente desde la línea de tiro."
        },
        "spotter": {
          "title": "Modo spotter",
          "subtitle": "Permite que otra persona registre el end con un flujo accesible."
        },
        "history": {
          "title": "Historial de entrenamiento",
          "subtitle": "Revisa sesiones, promedios, X y conteo de 10."
        },
        "accessibility": {
          "title": "Accesibilidad",
          "subtitle": "Ajusta contraste, asistencia del temporizador y feedback multimodal."
        },
        "profile": {
          "title": "Perfil",
          "subtitle": "Actualiza identidad del atleta, idioma y unidad de medida."
        }
      }
    },
    "timer": {
      "main": {
        "title": "Temporizador",
        "config_button": "Configurar",
        "countdown_label": "Tiempo restante",
        "arrows_label": "Flechas",
        "mode_label": "Modo",
        "start": "Iniciar",
        "pause": "Pausar",
        "reset": "Reiniciar",
        "next_end": "Siguiente End"
      },
      "modes": {
        "competition": "Reglas de competición",
        "per_arrow": "30 segundos por flecha"
      },
      "accessibility": {
        "title": "Temporizador accesible",
        "description": "Añade 10 segundos extra para cada flecha.",
        "enabled": "Activado",
        "disabled": "Desactivado"
      },
      "config": {
        "title": "Configuración del temporizador",
        "apply_button": "Aplicar configuración",
        "total_duration": "Duración total",
        "page_title": "Configurar temporizador",
        "total_arrows_label": "TOTAL DE FLECHAS",
        "series_per_round": "Series por ronda",
        "arrows_per_series": "Flechas por serie",
        "alternate_shooters": "Alternar tiradores (AB/CD)",
        "alternate_shooters_desc": "Cambio automático entre parejas",
        "time_presets": "Predefiniciones de tiempo",
        "start_button": "INICIAR TEMPORIZADOR"
      }
    },
    "training": {
      "register": {
        "title": "Registrar end",
        "distance": "Distancia",
        "bow_type": "Tipo de arco",
        "spotter_name": "Nombre del spotter",
        "by_user": "Atleta",
        "by_spotter": "Spotter",
        "save_button": "Guardar end",
        "selected_scores": "SCORES SELECCIONADOS",
        "edit_context": "Editar contexto",
        "spotter_toggle_title": "Registro por Spotter",
        "spotter_toggle_desc": "Marca si otra persona está anotando"
      },
      "spotter_mode": {
        "title": "Modo spotter",
        "description": "Usa esta pantalla cuando otra persona esté registrando el end para el atleta.",
        "start_button": "Iniciar registro con spotter",
        "page_title": "Registro del Spotter",
        "info_title": "Información del registro",
        "info_subtitle": "Confirma los detalles de la operación asistida",
        "active_label": "La asistencia del spotter está activada",
        "responsible_name": "Nombre del Spotter responsable",
        "finish_button": "Finalizar registro"
      },
      "history": {
        "title": "Historial de entrenamiento",
        "empty": "Todavía no se encontraron sesiones de entrenamiento.",
        "summary_label": "{} flechas • promedio {}"
      },
      "details": {
        "title": "Detalle del entrenamiento",
        "average": "Promedio",
        "total_arrows": "Total de flechas",
        "x_count": "Conteo de X",
        "ten_count": "Conteo de 10",
        "ends": "Ends",
        "end_summary": "Promedio {} • {} m • {}"
      }
    },
    "accessibility": {
      "title": "Accesibilidad",
      "high_contrast": {
        "label": "Tema de alto contraste",
        "description": "Incrementa el contraste y la separación visual de los elementos."
      },
      "timer_mode": {
        "label": "Modo de temporizador accesible",
        "description": "Añade tiempo extra por flecha según las reglas."
      },
      "announcements": {
        "title": "Anuncios del lector de pantalla",
        "subtitle": "Anuncia cambios importantes, como el final del temporizador."
      },
      "haptic": {
        "title": "Respuesta háptica",
        "subtitle": "Refuerza acciones críticas con vibración."
      },
      "personalize_title": "Personaliza la aplicación para tu comodidad.",
      "personalize_subtitle": "Todas las acciones tienen botones visibles y áreas de toque ampliadas.",
      "text_size_label": "Tamaño del texto",
      "text_size_hint": "Ajusta el tamaño para lectura dinámica (Dynamic Type)",
      "section_visual": "VISUAL E INTERACCIÓN",
      "section_alerts": "SEÑALES DE ALERTA",
      "section_reaction": "TIEMPO DE REACCIÓN"
    },
    "profile": {
      "title": "Perfil",
      "errors": {
        "no_user": "No hay ningún perfil de usuario disponible.",
        "not_found": "No se encontró perfil"
      },
      "fields": {
        "name": {
          "label": "Nombre",
          "subtitle": "Este nombre aparece en tu perfil de atleta."
        },
        "email": {
          "label": "Correo electrónico",
          "subtitle": "Tu correo de acceso proviene de Firebase Authentication."
        },
        "language": {
          "label": "Idioma preferido",
          "subtitle": "Elige el idioma de la aplicación para navegación y pantallas de puntuación.",
          "options": {
            "en": "Inglés (EE. UU.)",
            "pt": "Português (Brasil)",
            "es": "Español (España)"
          }
        },
        "units": {
          "label": "Unidad de distancia",
          "subtitle": "Define cómo se representan las distancias en campo.",
          "meters": "Metros",
          "yards": "Yardas"
        }
      },
      "save_button": "Guardar perfil",
      "level_label": "Nivel: Arquero intermedio",
      "app_settings_section": "CONFIGURACIÓN DE LA APP",
      "save_changes_button": "Guardar cambios",
      "sign_out_button": "Cerrar sesión"
    }
  }
};
static const Map<String,dynamic> _pt_BR = {
  "modules": {
    "auth": {
      "login": {
        "title": "Boas-vindas de volta",
        "subtitle": "Entre para manter seu treino focado e pronto para competição.",
        "email_label": "E-mail",
        "password_label": "Senha",
        "button": "Entrar"
      },
      "register": {
        "title": "Crie sua conta",
        "subtitle": "Configure seu perfil de atleta e sincronize seu histórico de treinos.",
        "name_label": "Nome",
        "confirm_password_label": "Confirmar senha",
        "button": "Criar conta",
        "back_to_login": "Voltar para entrar",
        "password_hint": "Use pelo menos 8 caracteres com letras e numeros",
        "terms_label": "Eu aceito os Termos de Uso e a Politica de Privacidade.",
        "create_button": "Criar minha conta"
      },
      "forgot_password": {
        "title": "Recuperar senha",
        "message": "Digite seu e-mail e enviaremos um link de redefinição.",
        "button": "Esqueceu a senha?",
        "send_reset_button": "Enviar e-mail de redefinição",
        "page_title": "Esqueceu sua senha?",
        "description": "Nao se preocupe, acontece com os melhores arqueiros. Insira seu e-mail abaixo e enviaremos as instrucoes para redefinir sua senha.",
        "email_section_label": "E-MAIL CADASTRADO",
        "send_link_button": "Enviar Link de Recuperacao"
      },
      "verification": {
        "title": "Verifique seu e-mail",
        "message": "Confirme seu e-mail antes de entrar no app.",
        "resend_button": "Reenviar e-mail de verificação",
        "check_button": "Já verifiquei meu e-mail",
        "sent_message": "Enviamos um link de verificacao para o seu endereco de e-mail cadastrado. Por favor, verifique sua caixa de entrada.",
        "back_to_login": "Voltar ao login",
        "not_received": "Nao recebeu o e-mail?",
        "resend_link": "Reenviar link"
      },
      "reset_password": {
        "title": "Redefinir senha",
        "message": "Cole o código recebido por e-mail e defina uma nova senha.",
        "code_label": "Código de ação",
        "button": "Atualizar senha",
        "page_title": "Nova Senha",
        "description": "Sua nova senha deve ser unica para proteger sua conta de arqueiro.",
        "strength_label": "Forca da senha",
        "submit_button": "REDEFINIR SENHA",
        "cancel_button": "Cancelar e voltar ao login"
      },
      "logout_button": "Sair"
    },
    "home": {
      "dashboard": {
        "title": "Painel",
        "greeting": "Bom treino, {}",
        "greeting_fallback": "arqueiro",
        "subtitle": "Acesso rápido ao timer, registro de pontuação e recursos de acessibilidade.",
        "coming_soon": "EM BREVE",
        "weekly_progress": "Progresso Semanal",
        "see_all": "Ver tudo",
        "welcome_back": "Bem-vinda de volta",
        "day_status": "STATUS DO DIA",
        "quick_access": "Acesso Rapido"
      },
      "summary": {
        "sessions": "Sessões",
        "arrows": "Flechas",
        "average": "Média",
        "x_count": "Contagem de X"
      },
      "shortcuts": {
        "timer": {
          "title": "Timer de competição",
          "subtitle": "Configure a contagem regressiva para 3 ou 6 flechas."
        },
        "register_end": {
          "title": "Registrar end",
          "subtitle": "Capture flechas e métricas direto da linha de tiro."
        },
        "spotter": {
          "title": "Modo spotter",
          "subtitle": "Permita que outra pessoa registre o end com fluxo acessível."
        },
        "history": {
          "title": "Histórico de treino",
          "subtitle": "Revise sessões, médias, X e contagem de 10."
        },
        "accessibility": {
          "title": "Acessibilidade",
          "subtitle": "Ajuste contraste, assistência do timer e feedback multimodal."
        },
        "profile": {
          "title": "Perfil",
          "subtitle": "Atualize identidade do atleta, idioma e unidade de medida."
        }
      }
    },
    "timer": {
      "main": {
        "title": "Timer",
        "config_button": "Configurar",
        "countdown_label": "Tempo restante",
        "arrows_label": "Flechas",
        "mode_label": "Modo",
        "start": "Iniciar",
        "pause": "Pausar",
        "reset": "Reiniciar",
        "next_end": "Proximo End"
      },
      "modes": {
        "competition": "Regras de competição",
        "per_arrow": "30 segundos por flecha"
      },
      "accessibility": {
        "title": "Timer acessível",
        "description": "Adiciona 10 segundos extras para cada flecha.",
        "enabled": "Ativado",
        "disabled": "Desativado"
      },
      "config": {
        "title": "Configurações do timer",
        "apply_button": "Aplicar configurações",
        "total_duration": "Duração total",
        "page_title": "Configurar Temporizador",
        "total_arrows_label": "TOTAL DE FLECHAS",
        "series_per_round": "Series por Rodada",
        "arrows_per_series": "Flechas por Serie",
        "alternate_shooters": "Alternar Atiradores (AB/CD)",
        "alternate_shooters_desc": "Troca automatica entre duplas",
        "time_presets": "Predefinicoes de Tempo",
        "start_button": "INICIAR TEMPORIZADOR"
      }
    },
    "training": {
      "register": {
        "title": "Registrar end",
        "distance": "Distância",
        "bow_type": "Tipo de arco",
        "spotter_name": "Nome do spotter",
        "by_user": "Atleta",
        "by_spotter": "Spotter",
        "save_button": "Salvar end",
        "selected_scores": "SCORES SELECIONADOS",
        "edit_context": "Editar contexto",
        "spotter_toggle_title": "Registro por Spotter",
        "spotter_toggle_desc": "Marque se outra pessoa estiver anotando"
      },
      "spotter_mode": {
        "title": "Modo spotter",
        "description": "Use esta tela quando outra pessoa estiver registrando o end para o atleta.",
        "start_button": "Iniciar registro com spotter",
        "page_title": "Registro do Spotter",
        "info_title": "Informacoes do Registro",
        "info_subtitle": "Confirme os detalhes da operacao assistida",
        "active_label": "O auxilio por spotter esta ativado",
        "responsible_name": "Nome do Spotter Responsavel",
        "finish_button": "Finalizar Registro"
      },
      "history": {
        "title": "Histórico de treino",
        "empty": "Nenhuma sessão de treino encontrada ainda.",
        "summary_label": "{} flechas • média {}"
      },
      "details": {
        "title": "Detalhe do treino",
        "average": "Média",
        "total_arrows": "Total de flechas",
        "x_count": "Contagem de X",
        "ten_count": "Contagem de 10",
        "ends": "Ends",
        "end_summary": "Média {} • {} m • {}"
      }
    },
    "accessibility": {
      "title": "Acessibilidade",
      "high_contrast": {
        "label": "Tema de alto contraste",
        "description": "Aumenta o contraste e a separação visual dos elementos."
      },
      "timer_mode": {
        "label": "Modo de timer acessível",
        "description": "Adiciona tempo extra por flecha de acordo com as regras."
      },
      "announcements": {
        "title": "Anúncios para leitor de tela",
        "subtitle": "Anuncia mudanças importantes, como o término do timer."
      },
      "haptic": {
        "title": "Feedback tátil",
        "subtitle": "Reforça ações críticas com vibração."
      },
      "personalize_title": "Personalize o app para o seu conforto.",
      "personalize_subtitle": "Todas as acoes possuem botoes visiveis e areas de toque ampliadas.",
      "text_size_label": "Tamanho do texto",
      "text_size_hint": "Ajuste o tamanho para leitura dinamica (Dynamic Type)",
      "section_visual": "VISUAL & INTERACAO",
      "section_alerts": "SINAIS DE ALERTA",
      "section_reaction": "TEMPO DE REACAO"
    },
    "profile": {
      "title": "Perfil",
      "errors": {
        "no_user": "Nenhum perfil de usuário disponível.",
        "not_found": "Nenhum perfil encontrado"
      },
      "fields": {
        "name": {
          "label": "Nome",
          "subtitle": "Esse nome aparece no seu perfil de atleta."
        },
        "email": {
          "label": "E-mail",
          "subtitle": "Seu e-mail de acesso vem do Firebase Authentication."
        },
        "language": {
          "label": "Idioma preferido",
          "subtitle": "Escolha o idioma do app para navegação e telas de pontuação.",
          "options": {
            "en": "Inglês (EUA)",
            "pt": "Português (Brasil)",
            "es": "Espanhol (Espanha)"
          }
        },
        "units": {
          "label": "Unidade de distância",
          "subtitle": "Defina como as distâncias em campo serão representadas.",
          "meters": "Metros",
          "yards": "Jardas"
        }
      },
      "save_button": "Salvar perfil",
      "level_label": "Nivel: Arqueiro Intermediario",
      "app_settings_section": "CONFIGURACOES DO APP",
      "save_changes_button": "Salvar alteracoes",
      "sign_out_button": "Sair da conta"
    }
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en_US": _en_US, "es_ES": _es_ES, "pt_BR": _pt_BR};
}
