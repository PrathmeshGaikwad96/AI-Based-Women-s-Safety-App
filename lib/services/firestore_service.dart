import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alert_model.dart';
import '../models/unsafe_place.dart';
import '../models/scheme_model.dart';
import '../models/rights_model.dart';
import '../models/guardian_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

class FirestoreService {
  final FirebaseFirestore? _db;
  bool _isFirebaseEnabled = false;

  FirestoreService({FirebaseFirestore? db}) : _db = db {
    if (_db != null) {
      _isFirebaseEnabled = true;
    }
  }

  // Check if Firebase is enabled
  bool get isFirebaseEnabled =>
      _isFirebaseEnabled && !AuthService.bypassFirebase;

  // Initialize simulated dummy data if needed
  Future<void> preseedDataIfNeeded() async {
    // Preseed Unsafe Zones
    final mockUnsafe = [
      UnsafePlace(
        id: 'PN-01',
        name: 'SPPU University Internal Roads',
        latitude: 18.5513,
        longitude: 73.8224,
        radius: 200,
        riskLevel: 'High Risk',
        description:
            'High isolation; thick vegetation. Located near Shivajinagar.',
        incidentCount: 14,
      ),
      UnsafePlace(
        id: 'PN-02',
        name: 'Hanuman Hill (Access Points)',
        latitude: 18.5284,
        longitude: 73.8315,
        radius: 200,
        riskLevel: 'High Risk',
        description:
            'Near-zero lighting; low night footfall. Located near Shivajinagar.',
        incidentCount: 8,
      ),
      UnsafePlace(
        id: 'PN-03',
        name: 'Model Colony (Lakaki Lake)',
        latitude: 18.5297,
        longitude: 73.8425,
        radius: 150,
        riskLevel: 'Moderate Risk',
        description:
            'Blind spots; narrow interior lanes. Located near Shivajinagar.',
        incidentCount: 5,
      ),
      UnsafePlace(
        id: 'PN-04',
        name: 'Old Wadarwadi Passages',
        latitude: 18.5350,
        longitude: 73.8340,
        radius: 120,
        riskLevel: 'High Risk',
        description:
            'High density; extreme poor lighting. Located near Shivajinagar.',
        incidentCount: 11,
      ),
      UnsafePlace(
        id: 'PN-05',
        name: 'Shivajinagar Rlwy Underpass',
        latitude: 18.5310,
        longitude: 73.8505,
        radius: 150,
        riskLevel: 'High Risk',
        description:
            'Infrastructure gap; defunct CCTV. Located near Shivajinagar.',
        incidentCount: 15,
      ),
      UnsafePlace(
        id: 'PN-06',
        name: 'FC Road/BMCC Road',
        latitude: 18.5215,
        longitude: 73.8406,
        radius: 180,
        riskLevel: 'Moderate Risk',
        description:
            'Deserted commercial zones after 11 PM. Located near Shivajinagar.',
        incidentCount: 6,
      ),
      UnsafePlace(
        id: 'PN-07',
        name: 'Bopdeo Ghat (Critical)',
        latitude: 18.4180,
        longitude: 73.9050,
        radius: 300,
        riskLevel: 'High Risk',
        description:
            'Total isolation; zero mobile network. Located near Hadapsar.',
        incidentCount: 22,
      ),
      UnsafePlace(
        id: 'PN-08',
        name: 'Sasane Nagar Rlwy Crossing',
        latitude: 18.4900,
        longitude: 73.9319,
        radius: 150,
        riskLevel: 'Moderate Risk',
        description:
            'Poor visibility; obstructed paths. Located near Hadapsar.',
        incidentCount: 7,
      ),
      UnsafePlace(
        id: 'PN-09',
        name: 'Magarpatta South Gate',
        latitude: 18.5130,
        longitude: 73.9340,
        radius: 180,
        riskLevel: 'Moderate Risk',
        description: 'Dark peripheral service roads. Located near Hadapsar.',
        incidentCount: 4,
      ),
      UnsafePlace(
        id: 'PN-10',
        name: 'Undri-Pisoli Road',
        latitude: 18.4550,
        longitude: 73.9010,
        radius: 200,
        riskLevel: 'Moderate Risk',
        description: 'Infrastructure lag; merged zones. Located near Kondhwa.',
        incidentCount: 9,
      ),
      UnsafePlace(
        id: 'PN-11',
        name: 'Lullanagar Liquor Vicinity',
        latitude: 18.4870,
        longitude: 73.8820,
        radius: 150,
        riskLevel: 'High Risk',
        description:
            'Proximity to unauthorized alcohol dens. Located near Kondhwa.',
        incidentCount: 16,
      ),
      UnsafePlace(
        id: 'PN-12',
        name: 'Mula-Mutha Riverfront (RFD)',
        latitude: 18.5440,
        longitude: 73.8880,
        radius: 250,
        riskLevel: 'High Risk',
        description:
            'Drug activity in thick river brush. Located near Yerwada.',
        incidentCount: 18,
      ),
      UnsafePlace(
        id: 'PN-13',
        name: 'Laxmi Nagar',
        latitude: 18.5520,
        longitude: 73.8810,
        radius: 150,
        riskLevel: 'High Risk',
        description: 'Unlit communal utility blocks. Located near Yerwada.',
        incidentCount: 12,
      ),
      UnsafePlace(
        id: 'PN-14',
        name: 'Ramwadi Metro Station',
        latitude: 18.5570,
        longitude: 73.9110,
        radius: 200,
        riskLevel: 'Moderate Risk',
        description:
            'Lack of surveillance in empty zones. Located near Vishrantwadi.',
        incidentCount: 5,
      ),
      UnsafePlace(
        id: 'PN-15',
        name: 'Mental Corner (Alandi Road)',
        latitude: 18.5610,
        longitude: 73.8850,
        radius: 180,
        riskLevel: 'Moderate Risk',
        description:
            'High anonymity at traffic hubs. Located near Vishrantwadi.',
        incidentCount: 8,
      ),
      UnsafePlace(
        id: 'PN-16',
        name: 'Budhwar Peth (Narrow Alleys)',
        latitude: 18.5170,
        longitude: 73.8580,
        radius: 150,
        riskLevel: 'High Risk',
        description:
            'High congestion; restricted access. Located near Faraskhana.',
        incidentCount: 20,
      ),
      UnsafePlace(
        id: 'PN-17',
        name: 'Rasta Peth / Somwar Peth',
        latitude: 18.5220,
        longitude: 73.8680,
        radius: 150,
        riskLevel: 'Moderate Risk',
        description:
            'Deserted and poor industrial lighting. Located near Samarth.',
        incidentCount: 6,
      ),
      UnsafePlace(
        id: 'PN-18',
        name: 'Swargate Bus Stand Subways',
        latitude: 18.5018,
        longitude: 73.8636,
        radius: 150,
        riskLevel: 'High Risk',
        description: 'Underground; CCTV blind spots. Located near Swargate.',
        incidentCount: 14,
      ),
      UnsafePlace(
        id: 'PN-19',
        name: 'Janata Vasahat (Parvati Hill)',
        latitude: 18.4910,
        longitude: 73.8450,
        radius: 200,
        riskLevel: 'High Risk',
        description:
            'Steep terrain; narrow unmonitored stairs. Located near Parvati.',
        incidentCount: 19,
      ),
      UnsafePlace(
        id: 'PN-20',
        name: 'ARAI Hill (Vetal Tekdi)',
        latitude: 18.5255,
        longitude: 73.8153,
        radius: 250,
        riskLevel: 'High Risk',
        description:
            'Forested tracks; zero night presence. Located near Kothrud.',
        incidentCount: 17,
      ),
      UnsafePlace(
        id: 'PN-21',
        name: 'Warje Flyover Underpasses',
        latitude: 18.4840,
        longitude: 73.8050,
        radius: 150,
        riskLevel: 'Moderate Risk',
        description:
            'Dark shadows under bridge infrastructure. Located near Warje.',
        incidentCount: 7,
      ),
      UnsafePlace(
        id: 'PN-22',
        name: 'Baner-Pashan Link Road',
        latitude: 18.5540,
        longitude: 73.7890,
        radius: 200,
        riskLevel: 'Moderate Risk',
        description:
            'Construction barricades blocking views. Located near Baner.',
        incidentCount: 5,
      ),
      UnsafePlace(
        id: 'PN-23',
        name: 'Phase 2 & 3 Service Roads',
        latitude: 18.5853,
        longitude: 73.6870,
        radius: 250,
        riskLevel: 'High Risk',
        description:
            'Isolated office stretches; few kiosks. Located near Hinjewadi.',
        incidentCount: 11,
      ),
      UnsafePlace(
        id: 'PN-24',
        name: 'Dighi Ghat/Hills',
        latitude: 18.6159,
        longitude: 73.8808,
        radius: 300,
        riskLevel: 'High Risk',
        description: 'Extreme isolation on city outskirts. Located near Dighi.',
        incidentCount: 13,
      ),
    ];

    if (_isFirebaseEnabled) {
      try {
        final unsafeSnapshot = await _db!
            .collection('unsafe_places')
            .limit(1)
            .get();
        if (unsafeSnapshot.docs.isEmpty) {
          final batch = _db.batch();
          for (final u in mockUnsafe) {
            batch.set(_db.collection('unsafe_places').doc(u.id), u.toMap());
          }
          await batch.commit();
        }

        // Seed rights in Firestore if empty
        final rightsSnapshot = await _db.collection('rights').limit(1).get();
        if (rightsSnapshot.docs.isEmpty) {
          final batch = _db.batch();
          for (final r in _getMockRights()) {
            batch.set(_db.collection('rights').doc(r.id), r.toMap());
          }
          await batch.commit();
        }

        // Seed schemes in Firestore if empty
        final schemesSnapshot = await _db.collection('schemes').limit(1).get();
        if (schemesSnapshot.docs.isEmpty) {
          final batch = _db.batch();
          for (final s in _getMockSchemes()) {
            batch.set(_db.collection('schemes').doc(s.id), s.toMap());
          }
          await batch.commit();
        }
      } catch (e) {
        print('Error seeding Firestore data: $e');
      }
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('preseeded_v5')) return;

    await prefs.setStringList(
      'mock_unsafe_places',
      mockUnsafe.map((u) => jsonEncode(u.toMap())).toList(),
    );

    // Preseed Rights
    final mockRights = _getMockRights();
    await prefs.setStringList(
      'mock_rights',
      mockRights.map((r) => jsonEncode(r.toMap())).toList(),
    );

    // Preseed Schemes
    final mockSchemes = _getMockSchemes();
    await prefs.setStringList(
      'mock_schemes',
      mockSchemes.map((s) => jsonEncode(s.toMap())).toList(),
    );

    // Preseed Circles/Guardians
    final mockGuardians = [
      GuardianModel(
        id: 'g1',
        name: 'Robert Vance (Dad)',
        phone: '+1 (555) 123-4567',
        relation: 'Father',
      ),
      GuardianModel(
        id: 'g2',
        name: 'Sarah Vance (Mom)',
        phone: '+1 (555) 987-6543',
        relation: 'Mother',
      ),
    ];
    await prefs.setStringList(
      'mock_guardians',
      mockGuardians.map((g) => jsonEncode(g.toMap())).toList(),
    );

    // Ensure no mock alerts exist
    await prefs.remove('mock_alerts');

    // Preseed users list (for Admin)
    final mockUsers = [
      UserModel(
        uid: 'demo_admin',
        name: 'SHRI Admin',
        email: 'admin@shri.com',
        phone: '9999999999',
        dob: '2000-01-01',
        address: 'Main Command Center',
        aadhaarImageUrl: '',
        guardianName: 'Backup Admin',
        guardianPhone: '8888888888',
        guardianRelation: 'Colleague',
        guardianIds: [],
        verificationStatus: 'approved',
        isBlocked: false,
        activityLog: [
          {
            'action': 'Mock Admin account initialized',
            'timestamp': DateTime.now().toIso8601String(),
          },
        ],
      ),
      UserModel(
        uid: 'demo_user',
        name: 'Maya',
        email: 'maya@hutter.ai',
        phone: '+1 (555) 444-5555',
        safetyScore: 98.0,
        guardianIds: ['g1', 'g2'],
      ),
      UserModel(
        uid: 'u_alice',
        name: 'Alice Smith',
        email: 'alice@hutter.ai',
        phone: '+1 (555) 333-2222',
        safetyScore: 84.0,
      ),
      UserModel(
        uid: 'u_clara',
        name: 'Clara Jones',
        email: 'clara@hutter.ai',
        phone: '+1 (555) 888-9999',
        safetyScore: 61.0,
        address: 'High Risk Metro Station',
        latitude: 40.7128 + 0.001,
        longitude: -74.0060 + 0.008,
      ),
    ];
    await prefs.setStringList(
      'mock_users',
      mockUsers.map((u) => jsonEncode(u.toMap())).toList(),
    );

    // Preseed credentials map for mock login
    final credentialsMap = jsonDecode(prefs.getString('mock_creds') ?? '{}');
    credentialsMap['admin@shri.com'] = {
      'uid': 'demo_admin',
      'password': 'admin123',
    };
    credentialsMap['maya@hutter.ai'] = {
      'uid': 'demo_user',
      'password': 'password123',
    };
    credentialsMap['alice@hutter.ai'] = {
      'uid': 'u_alice',
      'password': 'password123',
    };
    credentialsMap['clara@hutter.ai'] = {
      'uid': 'u_clara',
      'password': 'password123',
    };
    await prefs.setString('mock_creds', jsonEncode(credentialsMap));

    await prefs.setBool('preseeded_v5', true);
  }

  // Separate list functions to avoid massive method nesting
  List<RightsModel> _getMockRights() {
    return [
      RightsModel(
        id: 'r1',
        title: 'Domestic Violence Protection Act',
        description:
            'Provides comprehensive legal protection to women who face physical, emotional, sexual, or financial abuse within their household or family.',
        lawSection:
            'Section 498A (IPC) / Protection of Women from Domestic Violence Act, 2005',
        penalty:
            'Imprisonment up to 3 years and mandatory fines for the husband and relatives.',
        filingProcess:
            'File an FIR at the nearest police station, contact a local Protection Officer, or submit a complaint online at the National Commission for Women (NCW) portal.',
        downloadPdfUrl:
            'https://legislative.gov.in/sites/default/files/A2005-43.pdf',
      ),
      RightsModel(
        id: 'r2',
        title: 'Right to Free Legal Aid',
        description:
            'Guarantees that all women are entitled to free legal services and representation in court, ensuring financial limitations do not deny access to justice.',
        lawSection: 'Article 39A of the Constitution of India',
        penalty:
            'Violation of constitutional rights; the court is mandated to appoint free legal counsel to represent the female litigant.',
        filingProcess:
            'Submit a simple written application requesting representation to the District Legal Services Authority (DLSA) or State Legal Services Authority (SLSA).',
        downloadPdfUrl: 'https://nalsa.gov.in/acts-rules/constitution-of-india',
      ),
      RightsModel(
        id: 'r3',
        title: 'Protection from Sexual Harassment at Workplace (POSH Act)',
        description:
            'Creates a safe and equitable work environment for women, protecting them against harassment and providing redressal mechanisms.',
        lawSection: 'POSH Act 2013',
        penalty:
            'Fines up to ₹50,000, suspension of business license, and disciplinary action against the offender.',
        filingProcess:
            'File a formal written complaint to the Internal Complaints Committee (ICC) of your organization within 3 months of the incident.',
        downloadPdfUrl:
            'https://wcd.nic.in/act/handbook-sexual-harassment-women-workplace-preventing-prohibition-and-redressal-act-2013',
      ),
      RightsModel(
        id: 'r4',
        title: 'Dowry Prohibition Act',
        description:
            'Bans the giving, taking, demanding, or advertising of dowry in marriages, treating it as a non-bailable offense.',
        lawSection: 'Dowry Prohibition Act, 1961',
        penalty:
            'Minimum of 5 years imprisonment and a fine of ₹15,000 or the value of the dowry, whichever is higher.',
        filingProcess:
            'Report the demand to the Dowry Prohibition Officer of your district or register an FIR at the nearest police station.',
        downloadPdfUrl: 'https://www.indiacode.nic.in/handle/123456789/1622',
      ),
      RightsModel(
        id: 'r5',
        title: 'Assault to Outrage Modesty',
        description:
            'Criminalizes any assault or criminal force applied to a woman with the specific intent or knowledge that it will outrage her modesty.',
        lawSection: 'Section 354 (IPC)',
        penalty: 'Mandatory imprisonment of 1 to 5 years and a fine.',
        filingProcess:
            'File an FIR immediately at any police station. The statement must be recorded by a woman police officer.',
        downloadPdfUrl:
            'https://www.indiacode.nic.in/show-data?actid=AC_CEN_5_23_00037_186045_1527267789049',
      ),
      RightsModel(
        id: 'r6',
        title: 'Sexual Harassment and Punishment',
        description:
            'Explicitly defines and penalizes physical contact involving unwelcome sexual advances, demands for sexual favors, showing pornography, or making sexually colored remarks.',
        lawSection: 'Section 354A (IPC)',
        penalty: 'Rigorous imprisonment up to 3 years or fine, or both.',
        filingProcess:
            'File an FIR at the nearest police station or submit an e-complaint on the local state police portal.',
        downloadPdfUrl: 'https://www.indiacode.nic.in',
      ),
      RightsModel(
        id: 'r7',
        title: 'Assault with Intent to Disrobe',
        description:
            'Punishes the use of assault or criminal force to a woman with intent to disrobe or compel her to be naked in a public or private place.',
        lawSection: 'Section 354B (IPC)',
        penalty: 'Imprisonment of 3 to 7 years along with a fine.',
        filingProcess:
            'File an FIR immediately. Under the law, the victim\'s statement can be recorded at her residence or a convenient location of her choice.',
        downloadPdfUrl: 'https://www.indiacode.nic.in',
      ),
      RightsModel(
        id: 'r8',
        title: 'Punishment for Voyeurism',
        description:
            'Protects women from being watched, photographed, or recorded without consent in private settings (such as changing rooms, restrooms, or homes).',
        lawSection: 'Section 354C (IPC)',
        penalty:
            'Imprisonment of 1 to 3 years for the first conviction, and 3 to 7 years for subsequent offenses.',
        filingProcess:
            'Gather evidence (if safe) and file an FIR at the cyber cell or nearest police station.',
        downloadPdfUrl: 'https://www.indiacode.nic.in',
      ),
      RightsModel(
        id: 'r9',
        title: 'Punishment for Stalking',
        description:
            'Prohibits following a woman, contacting or attempting to contact her repeatedly despite her clear disinterest, or monitoring her online activities.',
        lawSection: 'Section 354D (IPC)',
        penalty:
            'Bailable for the first offense (up to 3 years imprisonment); non-bailable for subsequent offenses (up to 5 years).',
        filingProcess:
            'Save communication logs, screenshots, and call history, and file an FIR or report to the Cyber Crime division.',
        downloadPdfUrl: 'https://www.indiacode.nic.in',
      ),
      RightsModel(
        id: 'r10',
        title: 'Right to File a Zero FIR',
        description:
            'Allows a victim to file an FIR at any police station across India, regardless of where the crime occurred. The station must accept it and transfer it to the correct station.',
        lawSection: 'Criminal Law (Amendment) Act, 2013',
        penalty:
            'Disciplinary action or suspension against police officers who refuse to register a Zero FIR.',
        filingProcess:
            'Visit the nearest police station and insist on filing a Zero FIR. Ensure the serial number begins with "0".',
        downloadPdfUrl: 'https://mha.gov.in',
      ),
      RightsModel(
        id: 'r11',
        title: 'Right to Virtual Complaint',
        description:
            'Enables women who are unable to visit a police station to file legal complaints remotely via email, registered post, or online portals.',
        lawSection:
            'Delhi Police Guidelines / Ministry of Home Affairs Circulars',
        penalty:
            'Police are legally bound to acknowledge and register complaints sent via verified digital channels.',
        filingProcess:
            'Send a detailed email containing the complaint description, date, and witness details to the local Deputy Commissioner of Police (DCP).',
        downloadPdfUrl: 'https://mha.gov.in',
      ),
      RightsModel(
        id: 'r12',
        title: 'Confidentiality of Identity',
        description:
            'Protects the privacy and safety of survivors of sexual offenses by completely banning the publication or public disclosure of their names or identifiers.',
        lawSection: 'Section 228A (IPC)',
        penalty:
            'Imprisonment up to 2 years and a fine for anyone who discloses the victim\'s identity.',
        filingProcess:
            'If identity is disclosed by media or individuals, file a separate FIR under Section 228A at the local police station.',
        downloadPdfUrl: 'https://www.indiacode.nic.in',
      ),
      RightsModel(
        id: 'r13',
        title: 'Sunset Arrest Exception',
        description:
            'Protects women from police custody during night hours by ruling that no woman can be arrested after sunset and before sunrise, except in extraordinary circumstances.',
        lawSection: 'Section 46(4) of Code of Criminal Procedure (CrPC)',
        penalty:
            'Unlawful arrest; officers face departmental action and criminal charges for illegal detention.',
        filingProcess:
            'Inform the arresting officer of Section 46(4). If they insist, demand to see a written order signed by a Judicial Magistrate First Class.',
        downloadPdfUrl: 'https://www.indiacode.nic.in',
      ),
      RightsModel(
        id: 'r14',
        title: 'Medical Termination of Pregnancy',
        description:
            'Ensures women have the legal right to decide on safe abortions and access quality reproductive healthcare services without hazard.',
        lawSection: 'Medical Termination of Pregnancy (MTP) Act, 1971',
        penalty:
            'Unregistered practitioners performing abortions face up to 7 years of imprisonment.',
        filingProcess:
            'Visit a registered government hospital or private clinic approved under the MTP Act to consult a certified gynecologist.',
        downloadPdfUrl: 'https://main.mohfw.gov.in',
      ),
      RightsModel(
        id: 'r15',
        title: 'Maternity Benefit Rights',
        description:
            'Guarantees paid leave, medical bonuses, and job security for pregnant female employees in registered establishments.',
        lawSection: 'Maternity Benefit Act, 1961 (Amended 2017)',
        penalty:
            'Imprisonment up to 1 year or a fine up to ₹5000 for employers who deny benefits.',
        filingProcess:
            'Submit a written notice to your employer at least 10 weeks before the expected date of delivery requesting maternity leave.',
        downloadPdfUrl: 'https://labour.gov.in',
      ),
      RightsModel(
        id: 'r16',
        title: 'Equal Remuneration Act',
        description:
            'Mandates equal pay for equal work, banning gender-based discrimination in recruitment, wages, and promotions.',
        lawSection: 'Equal Remuneration Act, 1976',
        penalty:
            'Fines up to ₹20,000 or imprisonment for employers found practicing wage discrimination.',
        filingProcess:
            'File a complaint with the Labour Commissioner of your region or present the case to a Labour Court.',
        downloadPdfUrl: 'https://labour.gov.in',
      ),
      RightsModel(
        id: 'r17',
        title: 'Prohibition of Child Marriage',
        description:
            'Bans the marriage of girls under 18 and boys under 21, treating child marriages as voidable and protecting child victims.',
        lawSection: 'Prohibition of Child Marriage Act, 2006',
        penalty:
            'Rigorous imprisonment up to 2 years and a fine of ₹1 Lakh for adults performing or promoting child marriage.',
        filingProcess:
            'Report to the Child Marriage Prohibition Officer, contact the Childline helpline at 1098, or inform the local Panchayat.',
        downloadPdfUrl: 'https://wcd.nic.in',
      ),
      RightsModel(
        id: 'r18',
        title: 'Exemption from Station Summoning',
        description:
            'Establishes that police officers cannot summon a woman to the police station for questioning as a witness; questioning must happen at her residence.',
        lawSection: 'Section 160 of CrPC',
        penalty:
            'Summoning a woman against the law constitutes procedural misconduct; officers face disciplinary suspension.',
        filingProcess:
            'If a written or verbal summon is received to attend a station for questioning, cite Section 160 and request they visit your home in the presence of family.',
        downloadPdfUrl: 'https://www.indiacode.nic.in',
      ),
      RightsModel(
        id: 'r19',
        title: 'Right to She-Box Portal',
        description:
            'Provides a direct online portal (SHe-Box) for women working in both public and private sectors to file sexual harassment complaints directly to the Ministry of Women and Child Development.',
        lawSection: 'POSH Act Compliance Framework',
        penalty:
            'Non-compliance by employers in setting up ICCs results in a fine of ₹50,000 and license cancellation.',
        filingProcess:
            'Register and submit your complaint details online on the official SHe-Box website (shebox.wcd.gov.in).',
        downloadPdfUrl: 'http://shebox.wcd.gov.in',
      ),
      RightsModel(
        id: 'r20',
        title: 'Insult to Modesty (Words/Gestures)',
        description:
            'Punishes anyone who utters any word, makes any sound or gesture, or exhibits any object, intending that it shall be heard or seen by a woman to intrude upon her privacy or modesty.',
        lawSection: 'Section 509 (IPC)',
        penalty: 'Simple imprisonment up to 3 years and a fine.',
        filingProcess:
            'Record or note the words/gestures used, identify witnesses, and lodge an FIR at your local police station.',
        downloadPdfUrl: 'https://www.indiacode.nic.in',
      ),
      RightsModel(
        id: 'r21',
        title: 'Right to Free Medical Treatment',
        description:
            'Ensures that all public and private hospitals must immediately provide free first-aid or medical treatment to victims of acid attack or sexual assault without waiting for police clearance.',
        lawSection: 'Section 357C of CrPC',
        penalty:
            'Hospitals or doctors refusing treatment face criminal prosecution under Section 166B of the IPC (up to 1 year prison).',
        filingProcess:
            'In an emergency, head to the nearest hospital. If they refuse treatment, call the police helpline (112) or the health department immediately.',
        downloadPdfUrl: 'https://main.mohfw.gov.in',
      ),
      RightsModel(
        id: 'r22',
        title: 'Pre-Natal Diagnostic Restrictions',
        description:
            'Bans the use of pre-natal diagnostic techniques for sex determination, combating female foeticide and promoting gender balance.',
        lawSection: 'PCPNDT Act, 1994',
        penalty:
            'Imprisonment up to 3 to 5 years, fines up to ₹50,000, and cancellation of medical registration.',
        filingProcess:
            'Report clinics advertising or offering sex determination tests to the local PCPNDT Appropriate Authority or call 104.',
        downloadPdfUrl: 'https://main.mohfw.gov.in',
      ),
      RightsModel(
        id: 'r23',
        title: 'Prevention of Sati Commission',
        description:
            'Provides for the complete prevention of the commission of Sati (burning or burying alive of widows) and its glorification in any form.',
        lawSection: 'Commission of Sati (Prevention) Act, 1987',
        penalty:
            'Death penalty or life imprisonment for abetment of Sati; up to 7 years imprisonment for glorifying Sati.',
        filingProcess:
            'Inform the local District Magistrate or District Police Chief immediately if any attempt, ceremony, or glorification of Sati is observed.',
        downloadPdfUrl: 'https://wcd.nic.in',
      ),
      RightsModel(
        id: 'r24',
        title: 'Immoral Traffic Prevention',
        description:
            'Penalizes trafficking of women and girls for commercial sexual exploitation, and provides guidelines for rescue and rehabilitation.',
        lawSection: 'Immoral Traffic (Prevention) Act, 1956',
        penalty:
            'Rigorous imprisonment of 7 years to life, depending on the severity and age of the victim.',
        filingProcess:
            'Inform local police or file a report with the Anti-Human Trafficking Unit (AHTU) in your district, or call Childline 1098.',
        downloadPdfUrl: 'https://wcd.nic.in',
      ),
      RightsModel(
        id: 'r25',
        title: 'Indecent Representation Prohibition',
        description:
            'Prohibits indecent representation of women through advertisements, publications, writings, paintings, figures, or in any other media.',
        lawSection: 'Indecent Representation of Women (Prohibition) Act, 1986',
        penalty:
            'Imprisonment up to 2 years and a fine of ₹2000 for the first offense; higher penalties for subsequent offenses.',
        filingProcess:
            'Lodge a complaint with the cyber cell or the local police station against the publishing entity.',
        downloadPdfUrl: 'https://wcd.nic.in',
      ),
      RightsModel(
        id: 'r26',
        title: 'Right to Private Counseling & Shelter',
        description:
            'Entitles victims of domestic violence or sexual abuse to safe shelter home facilities and professional psychological counseling services funded by the state.',
        lawSection: 'Section 6 & 19 of the Domestic Violence Act, 2005',
        penalty:
            'Denying shelter by designated state service providers constitutes breach of statutory duty.',
        filingProcess:
            'Submit a request to the nearest Protection Officer, Service Provider, or call the Women Helpline (181) for shelter allocation.',
        downloadPdfUrl: 'https://wcd.nic.in',
      ),
    ];
  }

  List<SchemeModel> _getMockSchemes() {
    return [
      SchemeModel(
        id: 's1',
        title: 'Majhi Ladki Bahin Yojana',
        description:
            'Direct financial assistance program targeted at boosting women entrepreneurship, health benefits, and financial independence in Maharashtra.',
        eligibility:
            'Women residents of Maharashtra aged 18-65 with family income below ₹2.5 Lakhs per annum.',
        applicationSteps: [
          'Visit the official Majhi Ladki Bahin portal online.',
          'Register with Aadhaar Card and mobile verification.',
          'Upload income certificate, domicile document, and bank passbook.',
          'Submit the application and track approval status.',
        ],
        officialUrl: 'https://ladakibahin.maharashtra.gov.in',
        category: 'Financial Assistance',
      ),
      SchemeModel(
        id: 's2',
        title: 'Pradhan Mantri Matru Vandana Yojana',
        description:
            'Maternity benefit program offering cash incentives for pregnant and lactating mothers to ensure proper nutrition.',
        eligibility:
            'Pregnant women and lactating mothers for their first child, working in non-government sectors.',
        applicationSteps: [
          'Obtain mother-child protection card (MCP).',
          'Fill Form 1-A at the local Anganwadi center or healthcare center.',
          'Provide bank account details linked to Aadhaar.',
          'Direct cash payouts are processed in three installments directly.',
        ],
        officialUrl: 'https://pmmvy.wcd.gov.in',
        category: 'Maternal Care',
      ),
      SchemeModel(
        id: 's3',
        title: 'Post-Graduate Scholarship for Single Girl Child',
        description:
            'Aims to support higher education for girls who are the only child in their families.',
        eligibility:
            'Girl students up to 30 years of age, who are the single girl child in their family, pursuing a postgraduate degree.',
        applicationSteps: [
          'Apply online via the National Scholarship Portal (NSP).',
          'Upload certificate of single-child status signed by Gazetted Officer.',
          'Attach admission slip and university registration details.',
          'Verify application at the institutional level.',
        ],
        officialUrl: 'https://scholarships.gov.in',
        category: 'Education Support',
      ),
      SchemeModel(
        id: 's4',
        title: 'One Stop Centre (Sakhi)',
        description:
            'Provides integrated support and assistance under one roof to women affected by violence, in private and public spaces.',
        eligibility:
            'Any woman affected by violence, harassment, or domestic abuse in public or private spaces.',
        applicationSteps: [
          'Visit the nearest Sakhi One Stop Centre (OSC) in your district.',
          'Access immediate medical aid, counseling, legal aid, and temporary shelter (up to 5 days).',
          'A case manager will assist in filing FIR or securing legal protection.',
        ],
        officialUrl: 'https://wcd.gov.in',
        category: 'Safety & Protection',
      ),
      SchemeModel(
        id: 's5',
        title: 'Mahila Police Volunteers Scheme',
        description:
            'Establishes a link between police and community to ensure a safer environment for women in public and domestic environments.',
        eligibility:
            'Women aged 21 years and above, minimum 12th pass, residing in the local ward/village.',
        applicationSteps: [
          'Apply through the district Senior Superintendent of Police (SSP) notice.',
          'Submit local police verification and character certificate.',
          'Undergo basic training on women\'s rights and safety interventions.',
        ],
        officialUrl: 'https://www.myscheme.gov.in',
        category: 'Safety & Protection',
      ),
      SchemeModel(
        id: 's6',
        title: 'Working Women Hostels (Sankalp)',
        description:
            'Provides safe, clean, and affordable hostel accommodation for working women, along with daycare facilities for their children.',
        eligibility:
            'Working women earning up to ₹50,000 per month (metro) or ₹35,000 (other areas), and single students.',
        applicationSteps: [
          'Visit the hostel management office or check the WCD directory.',
          'Submit employment verification letter and salary slips.',
          'Fill out the local application form and pay a subsidized nominal deposit.',
        ],
        officialUrl: 'https://www.myscheme.gov.in',
        category: 'Welfare & Housing',
      ),
      SchemeModel(
        id: 's7',
        title: 'Beti Bachao Beti Padhao',
        description:
            'A national campaign to generate awareness and improve the efficiency of welfare services intended for girls, focusing on gender balance and education.',
        eligibility:
            'All citizens, parents, and community members with a focus on girl child welfare and education.',
        applicationSteps: [
          'Participate in local district sensitization camps.',
          'Enroll girls in primary education programs with zero fees.',
          'Avail educational and scholarship kits at local block centers.',
        ],
        officialUrl: 'https://wcd.gov.in',
        category: 'Education Support',
      ),
      SchemeModel(
        id: 's8',
        title: 'Swadhar Greh Scheme',
        description:
            'Provides shelter, food, clothing, counseling, and vocational training to women in difficult circumstances (abandoned, widows, survivors).',
        eligibility:
            'Women in difficult circumstances, destitute, survivors of domestic abuse or natural disasters.',
        applicationSteps: [
          'Contact the Swadhar Greh shelter directly or seek referral from a Protection Officer.',
          'Submit a basic statement detailing the circumstances.',
          'Admitted women receive free housing and rehabilitation support.',
        ],
        officialUrl: 'https://www.myscheme.gov.in',
        category: 'Welfare & Housing',
      ),
      SchemeModel(
        id: 's9',
        title: 'Ujjawala Prevention & Rescue',
        description:
            'A comprehensive scheme for prevention of trafficking and rescue, rehabilitation, and re-integration of victims of commercial sexual exploitation.',
        eligibility:
            'Trafficking survivors or women vulnerable to commercial sexual exploitation.',
        applicationSteps: [
          'Lodge a request with local NGOs or the Anti-Human Trafficking Unit.',
          'Rescue operations are carried out under administrative supervision.',
          'Admit to Ujjawala protection centers for psychological counseling and vocational training.',
        ],
        officialUrl: 'https://wcd.gov.in',
        category: 'Safety & Protection',
      ),
      SchemeModel(
        id: 's10',
        title: 'Support to Training and Employment (STEP)',
        description:
            'Provides skills to women that enable them to become self-employed/entrepreneurs, in sectors like agriculture, handicrafts, tailoring, etc.',
        eligibility:
            'Marginalized women aged 16 years and above, in rural or urban sectors.',
        applicationSteps: [
          'Enroll at a registered training partner or block-level community group.',
          'Select trade courses ranging from 3 to 12 months.',
          'Receive training certificates and job placement assistance.',
        ],
        officialUrl: 'https://www.myscheme.gov.in',
        category: 'Financial Assistance',
      ),
      SchemeModel(
        id: 's11',
        title: 'Women Helpline Scheme (181)',
        description:
            'Provides 24-hour immediate toll-free telecom response to women affected by violence, connecting them to police, hospitals, and shelter homes.',
        eligibility:
            'Any woman or girl seeking assistance or facing distress anywhere in India.',
        applicationSteps: [
          'Dial 181 from any mobile or landline device.',
          'Speak to the trained counselor who will assess the emergency.',
          'Dispatcher will coordinate with local PCR van or ambulance if needed.',
        ],
        officialUrl: 'https://www.myscheme.gov.in',
        category: 'Safety & Protection',
      ),
      SchemeModel(
        id: 's12',
        title: 'Nirbhaya Fund Projects',
        description:
            'Funding mechanism set up by the Government of India for safety and security initiatives for women across various ministries.',
        eligibility:
            'Institutions, local police forces, and transport departments implementing safety infrastructure.',
        applicationSteps: [
          'Observe safety features like emergency panic buttons in public transport.',
          'Use Nirbhaya funded CCTV surveillance corridors in major cities.',
          'Register grievances on safety apps connected to the Emergency Response Support System (ERSS).',
        ],
        officialUrl: 'https://www.mha.gov.in',
        category: 'Safety & Protection',
      ),
      SchemeModel(
        id: 's13',
        title: 'Mahila E-Haat',
        description:
            'An online marketing platform that leverages technology to help women entrepreneurs, self-help groups, and NGOs display and sell products.',
        eligibility:
            'Women entrepreneurs, self-help groups (SHGs), and cooperative societies.',
        applicationSteps: [
          'Visit the Mahila E-Haat portal (mahilaehaat-wcd.gov.in).',
          'Register using Aadhaar Card and enterprise registration details.',
          'Upload photos of handicrafts, garments, or organic products with pricing.',
          'Interact directly with buyers without intermediate commission.',
        ],
        officialUrl: 'https://www.myscheme.gov.in',
        category: 'Financial Assistance',
      ),
      SchemeModel(
        id: 's14',
        title: 'Safe City Project',
        description:
            'Creates safe, secure, and empowering public spaces for women in cities through improved lighting, patrolling, and emergency integration.',
        eligibility:
            'Public infrastructure initiative covering major cities (Delhi, Mumbai, Pune, Bangalore, etc.).',
        applicationSteps: [
          'Identify Pink Patrolling vans and police kiosks in your city.',
          'Utilize emergency call boxes (ECBs) installed on streets.',
          'Report unlit street spots to municipal authorities via the project helpline.',
        ],
        officialUrl: 'https://safecity.mha.gov.in',
        category: 'Safety & Protection',
      ),
      SchemeModel(
        id: 's15',
        title: 'Sukanya Samriddhi Yojana',
        description:
            'Small deposit scheme for the girl child, offering high interest rates and tax exemptions to secure their future education and marriage.',
        eligibility:
            'Parents or legal guardians of a girl child below 10 years of age (maximum 2 girl children per family).',
        applicationSteps: [
          'Visit any post office or authorized national bank branch.',
          'Fill out the application form with the child\'s birth certificate.',
          'Open account with a minimum initial deposit of ₹250.',
        ],
        officialUrl: 'https://www.nsiindia.gov.in',
        category: 'Financial Assistance',
      ),
      SchemeModel(
        id: 's16',
        title: 'Stand Up India Scheme',
        description:
            'Promotes entrepreneurship at the grassroots level by offering bank loans between ₹10 Lakhs and ₹1 Crore to women and SC/ST borrowers.',
        eligibility:
            'Women entrepreneurs above 18 years of age looking to set up greenfield enterprises.',
        applicationSteps: [
          'Visit the Stand-Up Mitra portal (standupmitra.in).',
          'Submit business plan proposals and credit histories.',
          'Receive loan support with subsidized interest rates and credit guarantees.',
        ],
        officialUrl: 'https://www.standupmitra.in',
        category: 'Financial Assistance',
      ),
      SchemeModel(
        id: 's17',
        title: 'Mudra Loan (Mahila Udhyami)',
        description:
            'Collateral-free micro-credit business loans up to ₹10 Lakhs provided to women starting small businesses and service setups.',
        eligibility:
            'Women entrepreneurs starting or running manufacturing, retail, or service units.',
        applicationSteps: [
          'Choose loan category: Shishu (up to ₹50k), Kishor (up to ₹5L), or Tarun (up to ₹10L).',
          'Submit identity proof, business license, and quotation of equipment.',
          'Apply at any commercial or rural cooperative bank.',
        ],
        officialUrl: 'https://www.mudra.org.in',
        category: 'Financial Assistance',
      ),
      SchemeModel(
        id: 's18',
        title: 'Kasturba Gandhi Balika Vidyalaya',
        description:
            'Residential schools set up to provide primary education to girls belonging to Scheduled Castes, Tribes, OBC, and Below Poverty Line.',
        eligibility:
            'Girl students from disadvantaged backgrounds who are out of school or dropouts.',
        applicationSteps: [
          'Contact the block education officer (BEO) or visit the local KGBV school.',
          'Submit caste certificate, income verification, and previous school records.',
          'Selected girls receive free lodging, board, uniforms, and education.',
        ],
        officialUrl: 'https://education.gov.in',
        category: 'Education Support',
      ),
      SchemeModel(
        id: 's19',
        title: 'Free Bicycle Scheme for Girls',
        description:
            'State-sponsored schemes to encourage secondary education among girls in rural areas by providing free bicycles to commute to school.',
        eligibility:
            'Girl students enrolled in class 9th or higher in rural government schools.',
        applicationSteps: [
          'Schools automatically collect candidate lists at the beginning of the term.',
          'Provide student Aadhaar card and certificate of attendance.',
          'Bicycles are distributed at public block ceremonies or via school funding.',
        ],
        officialUrl: 'https://education.gov.in',
        category: 'Education Support',
      ),
      SchemeModel(
        id: 's20',
        title: 'Rashtriya Mahila Kosh (RMK)',
        description:
            'A national-level micro-finance organization providing loans to intermediate organizations for onward lending to poor women for livelihood.',
        eligibility:
            'Poor, assetless women in informal sectors looking to fund agriculture, dairy, or handloom.',
        applicationSteps: [
          'Join a local registered Women Self Help Group (SHG) or NGO.',
          'Submit group proposal for collective credit to the local block coordinator.',
          'Receive micro-credit disbursements directly into the group bank account.',
        ],
        officialUrl: 'https://www.myscheme.gov.in',
        category: 'Financial Assistance',
      ),
    ];
  }

  // --- ALERTS SERVICE ---
  Future<void> triggerAlert(AlertModel alert) async {
    if (_isFirebaseEnabled) {
      await _db!.collection('alerts').doc(alert.id).set(alert.toMap());
    } else {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('mock_alerts') ?? [];
      list.insert(0, jsonEncode(alert.toMap()));
      await prefs.setStringList('mock_alerts', list);

      // Also update user's location & status in mock users list
      final usersList = prefs.getStringList('mock_users') ?? [];
      for (int i = 0; i < usersList.length; i++) {
        final u = UserModel.fromMap(jsonDecode(usersList[i]));
        if (u.uid == alert.userId) {
          final updatedUser = u.copyWith(
            latitude: alert.latitude,
            longitude: alert.longitude,
            batteryLevel: alert.batteryLevel,
            address: alert.address,
          );
          usersList[i] = jsonEncode(updatedUser.toMap());
          break;
        }
      }
      await prefs.setStringList('mock_users', usersList);
    }
  }

  Future<void> resolveAlert(String alertId, String resolutionMessage) async {
    if (_isFirebaseEnabled) {
      await _db!.collection('alerts').doc(alertId).update({
        'status': 'resolved',
        'aiMonitoringStatus': resolutionMessage,
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('mock_alerts') ?? [];
      for (int i = 0; i < list.length; i++) {
        final a = AlertModel.fromMap(jsonDecode(list[i]));
        if (a.id == alertId) {
          final updated = a.copyWith(
            status: 'resolved',
            aiMonitoringStatus: resolutionMessage,
          );
          list[i] = jsonEncode(updated.toMap());
          break;
        }
      }
      await prefs.setStringList('mock_alerts', list);
    }
  }

  Future<List<AlertModel>> fetchAlertsHistory() async {
    await preseedDataIfNeeded();
    if (_isFirebaseEnabled) {
      final query = await _db!
          .collection('alerts')
          .orderBy('timestamp', descending: true)
          .get();
      return query.docs.map((doc) => AlertModel.fromMap(doc.data())).toList();
    } else {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('mock_alerts') ?? [];
      return list.map((item) => AlertModel.fromMap(jsonDecode(item))).toList();
    }
  }

  // --- GUARDIANS / CIRCLE SERVICE ---
  Future<List<GuardianModel>> fetchCircle(String userId) async {
    await preseedDataIfNeeded();
    if (_isFirebaseEnabled) {
      final query = await _db!
          .collection('users')
          .doc(userId)
          .collection('guardians')
          .get();
      return query.docs
          .map((doc) => GuardianModel.fromMap(doc.data()))
          .toList();
    } else {
      final prefs = await SharedPreferences.getInstance();
      final list =
          prefs.getStringList('mock_guardians_$userId') ??
          prefs.getStringList('mock_guardians') ??
          [];
      return list
          .map((item) => GuardianModel.fromMap(jsonDecode(item)))
          .toList();
    }
  }

  Future<void> addGuardian(String userId, GuardianModel guardian) async {
    if (_isFirebaseEnabled) {
      await _db!
          .collection('users')
          .doc(userId)
          .collection('guardians')
          .doc(guardian.id)
          .set(guardian.toMap());
    } else {
      final prefs = await SharedPreferences.getInstance();
      final list =
          prefs.getStringList('mock_guardians_$userId') ??
          prefs.getStringList('mock_guardians') ??
          [];
      list.add(jsonEncode(guardian.toMap()));
      await prefs.setStringList('mock_guardians_$userId', list);
    }
  }

  Future<void> removeGuardian(String userId, String id) async {
    if (_isFirebaseEnabled) {
      await _db!
          .collection('users')
          .doc(userId)
          .collection('guardians')
          .doc(id)
          .delete();
    } else {
      final prefs = await SharedPreferences.getInstance();
      final list =
          prefs.getStringList('mock_guardians_$userId') ??
          prefs.getStringList('mock_guardians') ??
          [];
      list.removeWhere(
        (item) => GuardianModel.fromMap(jsonDecode(item)).id == id,
      );
      await prefs.setStringList('mock_guardians_$userId', list);
    }
  }

  // --- UNSAFE PLACES / RISK HOTSPOTS ---
  Future<List<UnsafePlace>> fetchUnsafePlaces() async {
    await preseedDataIfNeeded();
    if (_isFirebaseEnabled) {
      final query = await _db!.collection('unsafe_places').get();
      return query.docs.map((doc) => UnsafePlace.fromMap(doc.data())).toList();
    } else {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('mock_unsafe_places') ?? [];
      return list.map((item) => UnsafePlace.fromMap(jsonDecode(item))).toList();
    }
  }

  Future<void> addUnsafePlace(UnsafePlace place) async {
    if (_isFirebaseEnabled) {
      await _db!.collection('unsafe_places').doc(place.id).set(place.toMap());
    } else {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('mock_unsafe_places') ?? [];
      list.add(jsonEncode(place.toMap()));
      await prefs.setStringList('mock_unsafe_places', list);
    }
  }

  // --- RIGHTS & GOVERNMENT SCHEMES ---
  Future<List<RightsModel>> fetchRights() async {
    await preseedDataIfNeeded();
    if (_isFirebaseEnabled) {
      final query = await _db!.collection('rights').get();
      return query.docs.map((doc) => RightsModel.fromMap(doc.data())).toList();
    } else {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('mock_rights') ?? [];
      return list.map((item) => RightsModel.fromMap(jsonDecode(item))).toList();
    }
  }

  Future<List<SchemeModel>> fetchSchemes() async {
    await preseedDataIfNeeded();
    if (_isFirebaseEnabled) {
      final query = await _db!.collection('schemes').get();
      return query.docs.map((doc) => SchemeModel.fromMap(doc.data())).toList();
    } else {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('mock_schemes') ?? [];
      return list.map((item) => SchemeModel.fromMap(jsonDecode(item))).toList();
    }
  }

  // --- ADMIN USERS PORTAL ---
  Future<List<UserModel>> adminFetchUsers() async {
    await preseedDataIfNeeded();
    if (_isFirebaseEnabled) {
      final query = await _db!.collection('users').get();
      return query.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    } else {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('mock_users') ?? [];
      return list.map((item) => UserModel.fromMap(jsonDecode(item))).toList();
    }
  }

  Future<void> adminSetUserSafetyScore(String uid, double newScore) async {
    if (_isFirebaseEnabled) {
      await _db!.collection('users').doc(uid).update({'safetyScore': newScore});
    } else {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('mock_users') ?? [];
      for (int i = 0; i < list.length; i++) {
        final u = UserModel.fromMap(jsonDecode(list[i]));
        if (u.uid == uid) {
          list[i] = jsonEncode(u.copyWith(safetyScore: newScore).toMap());
          break;
        }
      }
      await prefs.setStringList('mock_users', list);
    }
  }

  // Update user verification status (approved / rejected / pending)
  Future<void> adminUpdateVerificationStatus(String uid, String status) async {
    if (_isFirebaseEnabled) {
      await _db!.collection('users').doc(uid).update({
        'verificationStatus': status,
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('mock_users') ?? [];
      for (int i = 0; i < list.length; i++) {
        final u = UserModel.fromMap(jsonDecode(list[i]));
        if (u.uid == uid) {
          final updated = u.copyWith(verificationStatus: status);
          list[i] = jsonEncode(updated.toMap());
          break;
        }
      }
      await prefs.setStringList('mock_users', list);
    }
  }

  // Set user blocked / unblocked status
  Future<void> adminSetBlockedStatus(String uid, bool isBlocked) async {
    if (_isFirebaseEnabled) {
      await _db!.collection('users').doc(uid).update({'isBlocked': isBlocked});
    } else {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('mock_users') ?? [];
      for (int i = 0; i < list.length; i++) {
        final u = UserModel.fromMap(jsonDecode(list[i]));
        if (u.uid == uid) {
          final updated = u.copyWith(isBlocked: isBlocked);
          list[i] = jsonEncode(updated.toMap());
          break;
        }
      }
      await prefs.setStringList('mock_users', list);
    }
  }

  // Log user activity
  Future<void> logUserActivity(String uid, String action) async {
    final activityEvent = {
      'action': action,
      'timestamp': DateTime.now().toIso8601String(),
    };
    if (_isFirebaseEnabled) {
      await _db!.collection('users').doc(uid).update({
        'activityLog': FieldValue.arrayUnion([activityEvent]),
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('mock_users') ?? [];
      for (int i = 0; i < list.length; i++) {
        final u = UserModel.fromMap(jsonDecode(list[i]));
        if (u.uid == uid) {
          final updatedLog = List<Map<String, dynamic>>.from(u.activityLog)
            ..add(activityEvent);
          final updated = u.copyWith(activityLog: updatedLog);
          list[i] = jsonEncode(updated.toMap());
          break;
        }
      }
      await prefs.setStringList('mock_users', list);
    }
  }

  // --- LIVE LOCATION SHARING ---
  Future<void> saveLiveLocation(
    String userId,
    double latitude,
    double longitude,
    int battery,
  ) async {
    if (_isFirebaseEnabled) {
      await _db!.collection('live_locations').doc(userId).set({
        'userId': userId,
        'latitude': latitude,
        'longitude': longitude,
        'batteryLevel': battery,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      final data = {
        'userId': userId,
        'latitude': latitude,
        'longitude': longitude,
        'batteryLevel': battery,
        'timestamp': DateTime.now().toIso8601String(),
      };
      await prefs.setString('live_location_$userId', jsonEncode(data));
    }
  }

  Future<void> deleteLiveLocation(String userId) async {
    if (_isFirebaseEnabled) {
      await _db!.collection('live_locations').doc(userId).delete();
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('live_location_$userId');
    }
  }

  // --- REALTIME STREAMS ---
  Stream<List<AlertModel>> getActiveAlertsStream() {
    if (_isFirebaseEnabled) {
      return _db!
          .collection('alerts')
          .where('status', isEqualTo: 'active')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => AlertModel.fromMap(doc.data()))
                .toList(),
          );
    } else {
      return Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
        final list = await fetchAlertsHistory();
        return list.where((a) => a.status == 'active').toList();
      });
    }
  }

  Stream<List<AlertModel>> getResolvedAlertsStream() {
    if (_isFirebaseEnabled) {
      return _db!
          .collection('alerts')
          .where('status', isEqualTo: 'resolved')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => AlertModel.fromMap(doc.data()))
                .toList(),
          );
    } else {
      return Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
        final list = await fetchAlertsHistory();
        return list.where((a) => a.status == 'resolved').toList();
      });
    }
  }

  Stream<Map<String, dynamic>?> getLiveLocationStream(String userId) {
    if (_isFirebaseEnabled) {
      return _db!
          .collection('live_locations')
          .doc(userId)
          .snapshots()
          .map((doc) => doc.data());
    } else {
      return Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
        final prefs = await SharedPreferences.getInstance();
        final jsonStr = prefs.getString('live_location_$userId');
        if (jsonStr != null) {
          return jsonDecode(jsonStr) as Map<String, dynamic>;
        }
        return null;
      });
    }
  }
}
