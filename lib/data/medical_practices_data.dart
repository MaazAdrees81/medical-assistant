class PracticeData {
  static List<String> practiceType = ['Primary Care Physician', 'Specialist Physician'];

  static Map<String, List<String>> practiceSubtypes = {
    'Primary Care Physician': [
      'Family Physician',
      'Geriatrician',
      'Internist',
      'Pediatrician',
    ],
    'Specialist Physician': [
      'Allergist /Immunologist',
      'Anesthesiologist',
      'Cardiologist',
      'Colon and Rectal Surgeon',
      'Critical Care Medicine Specialist',
      'Dentist',
      'Dermatologist',
      'Endocrinologist',
      'Emergency Medicine Specialist',
      'Gastroenterologist',
      'Haematologist',
      'Hepatologist',
      'Hospice and Palliative Medicine Specialist',
      'Infectious Disease Specialist',
      'Medical Geneticist',
      'Neonatologist',
      'Nephrologist',
      'Neurologist',
      'Nuclear Medicine Radiologist',
      'Obstetrician and Gynecologist',
      'Oncologist',
      'Ophthalmologist',
      'Osteopath',
      'Otolaryngologist/ENT Specialist',
      'Pathologist',
      'Physiatrist',
      'Plastic Surgeon',
      'Podiatrist',
      'Preventive Medicine Specialist',
      'Psychiatrist',
      'Pulmonologist',
      'Radiologist',
      'Rheumatologist',
      'Surgeon',
      'Urologist',
    ]
  };

  static List<String> addAllSubpractices() {
    List<String> all = practiceSubtypes['Primary Care Physician'];
    all.addAll(practiceSubtypes['Specialist Physician']);
    return all;
  }

  static List<String> allSubpractices = addAllSubpractices();

  static Map<String, String> practiceDescription = {
    'Allergist /Immunologist':
        'Specialists in allergy and immunology work with both adult and pediatric patients suffering from allergies and diseases of the respiratory tract or immune system. They may help patients suffering from common diseases such as asthma, eczema, food and drug allergies, insect sting allergies, immune deficiencies, some autoimmune diseases and diseases of the lung.',
    'Anesthesiologist':
        'These doctors give you drugs to numb your pain or to put you under during surgery, childbirth, or other procedures. They monitor your vital signs while you’re under anesthesia.',
    'Cardiologist':
        'Cardiologists are the specialists in the identification and treatment of diseases associated with the cardiovascular system (i.e. encompassing the heart and blood vessels). They also educate their patients about the causes of heart disease and determine the best treatment for their unique condition. You might see them for heart failure, a heart attack, high blood pressure, or an irregular heartbeat.',
    'Colon and Rectal Surgeon':
        'You would see these doctors for problems with your small intestine, colon, and bottom. They can treat colon cancer, hemorrhoids, and inflammatory bowel disease.',
    'Critical Care Medicine Specialist':
        'They care for people who are critically ill or injured, often heading intensive care units in hospitals. You might see them if your heart or other organs are failing or if you’ve been in an accident.',
    'Dentist':
        'A dentist, also known as a dental surgeon, is a surgeon who specializes in dentistry, the diagnosis, prevention, and treatment of diseases and conditions of the oral cavity.',
    'Dermatologist':
        'Dermatologists are physicians who treat adult and pediatric patients with disorders of the skin, hair, nails, scars, acne, or skin allergies and adjacent mucous membranes. They diagnose everything from skin cancer, tumors, inflammatory diseases of the skin, and infectious diseases. They also perform skin biopsies and dermatological surgical procedures.',
    'Endocrinologist':
        'Endocrinologists treat disorders and conditions that affect the endocrine system. This system involves various glands that make and release hormones in the body. These are experts on hormones and metabolism. They can treat conditions like diabetes, thyroid problems, infertility, and calcium and bone disorders.',
    'Emergency Medicine Specialist':
        'Physicians specializing in emergency medicine provide care for adult and pediatric patients in emergency situations. These doctors make life-or-death decisions for sick and injured people, usually in an emergency room to prevent further injury. Their job is to save lives and to avoid or lower the chances of disability.',
    'Family Physician':
        'While many medical specialties focus on a certain function of the body or particular organ, family medicine focuses on integrated care and treating the patient as a whole. They care for the whole family, including children, adults, and the elderly. They do routine checkups and screening tests, give you flu and immunization shots, and manage diabetes and other ongoing medical conditions.',
    'Gastroenterologist':
        'They’re specialists in digestive organs, including the stomach, bowels, esophagus, pancreas, liver, small intestine, colon, and gallbladder. You might see them for abdominal pain, ulcers, diarrhea, jaundice, or cancers in your digestive organs. They also perform procedures such as endoscopy, sigmoidoscopy, colonoscopy and other tests for colon cancer.',
    'Geriatrician':
        'These doctors care for the elderly. They can treat people in their homes, doctors offices, nursing homes, assisted-living centers, and hospitals.',
    'Haematologist':
        'These are specialists in diseases of the blood, spleen, and lymph glands, like sickle cell disease, anemia, hemophilia, and leukemia.',
    'Hepatologist':
        'Hepatologists are specialized doctors in the prevention, identification and treatment of diseases that affect the liver, gall bladder, biliary tree and pancreas. Hepatologists deal most frequently with viral hepatitis and diseases related to alcohol',
    'Hospice and Palliative Medicine Specialist':
        'They work with people who are nearing death. They’re experts in pain management. They work with a team of other doctors to keep up your quality of life.',
    'Infectious Disease Specialist':
        'They diagnose and treat infections in any part of your body, like fevers, Lyme disease, pneumonia, tuberculosis, and HIV and AIDS. Some of them specialize in preventive medicine or travel medicine.',
    'Internist':
        'An internist is a physician who treats diseases of the heart, blood, kidneys, joints, digestive, respiratory, and vascular systems (internal organs) of adolescent, adult, and elderly patients. These primary-care doctors treat both common and complex illnesses. You’ll likely visit them or your family doctor first for any condition. Internists often have advanced training in a host of subspecialties, like heart disease, cancer, or adolescent or sleep medicine.',
    'Medical Geneticist':
        'A medical geneticist is a physician who treats hereditary disorders and diagnoses diseases that are caused by genetic defects. Medical geneticists may provide patients with therapeutic interventions and specialized counseling. They also educate patients and their families on their diagnoses and how to cope with their genetic disorder. Medical geneticists conduct cytogenetic, radiologic, ,biochemical testing, some other screening tests and scientific research in the field.',
    'Neonatologist':
        'Neonatology is a subspecialty of pediatrics that consists of the medical care of newborn infants, especially the ill or premature newborn. It is a hospital-based specialty, and is usually practised in neonatal intensive care units. They may also provide antenatal consultation for women with certain risk factors, such as multiple births.',
    'Nephrologist':
        'They treat kidney diseases as well as high blood pressure and fluid and mineral imbalances linked to kidney disease. Nephrologists can also perform kidney transplants and dialysis.',
    'Neurologist':
        'Neurologists diagnose and treat diseases of the brain, spinal cord, peripheral nerves, muscles, autonomic nervous system, and blood vessels. Neurologists treat patients suffering from strokes, seizures, brain and spinal tumors, epilepsy, Parkinson\'s disease, and Alzheimer\'s disease.',
    'Nuclear Medicine Radiologist':
        'They use radioactive materials to diagnose and treat diseases. Utilizing techniques such as scintigraphy, these physicians analyze images of the body\'s organs to visualize certain diseases. They may also use radiopharmaceuticals to treat hyperthyroidism, thyroid cancer, tumors, and bone cancer.',
    'Obstetrician and Gynecologist':
        'Often called OB/GYNs, these doctors focus on women\'s health. Obstetrician deals with all aspects of pregnancy from delivering babies and providing medical care to women during pregnancy (antenatal care) and after the birth (postnatal care). They have the skills to manage complex or high-risk pregnancies and births, and can perform interventions and caesareans (C Sections). OB/GYNs are trained in both areas. But some of them may focus on women\'s reproductive health (gynecologists) and provide therapies to help you get pregnant, such as fertility treatments',
    'Oncologist':
        'These internists are cancer specialists. They do chemotherapy treatments and often work with radiation oncology and surgical oncology. A Radiation oncologists treat cancer with the use of high-energy radiation by targeting them in small areas of the body. They damage the DNA of cancer cells, preventing further growth. A Surgical oncologist is a surgeon who specializes in performing biopsies and removing cancerous tumors and surrounding tissue, as well as other cancer-related operations',
    'Ophthalmologist':
        'Physicians specializing in ophthalmology develop comprehensive medical and surgical care of the eyes. You can call them eye doctors. Ophthalmologists diagnose and treat vision problems. They may treat strabismus, diabetic retinopathy, or perform surgeries on cataracts or corneal transplantation.They can prescribe glasses or contact lenses and diagnose and treat diseases like glaucoma. Unlike optometrists, they’re medical doctors who can treat every kind of eye condition as well as operate on the eyes.',
    'Osteopath':
        'Doctors of osteopathic medicine (DO) are fully licensed medical doctors just like MDs. Their training stresses a “whole body” approach. Osteopaths use the latest medical technology but also the body’s natural ability to heal itself.',
    'Otolaryngologist/ENT Specialist':
        'Otolaryngologists are sometimes known as “ear, nose, and throat” (ENT) doctors. They treat diseases in the ears, nose, throat, tonsils, sinuses, head, neck, and respiratory system. They also can do reconstructive and plastic surgery on your head and neck.',
    'Pathologist':
        'A physician specializing in pathology studies the causes and nature of diseases. Through microscopic examination and clinical lab tests, pathologists work to diagnose, monitor, and treat diseases.They examine tissues, cells, and body fluids, applying biological, chemical, and physical sciences within the laboratory. They may examine tissues to determine whether an organ transplant is needed, or they may examine the blood of a pregnant woman to ensure the health of the fetus.',
    'Pediatrician':
        'They care for children from infancy (birth) to adolescence. Pediatricians practice preventative medicine and also diagnose common childhood diseases, such as asthma, allergies, and croup.Some pediatricians specialize in pre-teens and teens, child abuse, or children\'s developmental issues.',
    'Physiatrist':
        'These are Physicians specializing in physical medicine and rehabilitation work to help patients with disabilities of the brain, spinal cord, nerves, bones, joints, ligaments, muscles, tendons, sports injuries as well as other disabilities caused by accidents or diseases. Physiatrist work with patients of all ages and design care plans for conditions, such as spinal cord or brain injury, stroke, multiple sclerosis, and musculoskeletal and pediatric rehabilitation. Unlike many other medical specialties, physiatrists work to improve patient quality of life, rather than seek medical cures.',
    'Plastic Surgeon':
        'You might call them cosmetic surgeons. They rebuild or repair your skin, face, hands, breasts, or body. That can happen after an injury or disease or for cosmetic reasons.',
    'Podiatrist':
        'They care for problems in your ankles and feet. That can include injuries from accidents or sports or from ongoing health conditions like diabetes. Some podiatrists have advanced training in other subspecialties of the foot.',
    'Preventive Medicine Specialist':
        'They focus on keeping you well. They may work in public health or at hospitals. Some focus on treating people with addictions, illnesses from exposure to drugs, chemicals, and poisons, and other areas.  Their expertise goes far beyond preventative practices in clinical medicine, covering elements of biostatistics, epidemiology, environmental and occupational medicine, and even the evaluation and management of health services and healthcare organizations. The field combines interdisciplinary elements of medical, social, economic, and behavioral sciences to understand the causes of disease and injury in population groups.',
    'Psychiatrist':
        'These doctors work with people with mental, emotional, or addictive disorders. They can diagnose and treat depression, schizophrenia, substance abuse, anxiety disorders, and sexual and gender identity issues. Understanding the connections between genetics, emotion, and mental illness, is important while psychiatrists also conduct medical laboratory and psychological tests to diagnose and treat patients.',
    'Pulmonologist':
        'Pulmonologists focus on the organs involved with breathing. These include the lungs and heart. You would see these specialists for problems like lung cancer, pneumonia, asthma, emphysema, and trouble sleeping caused by breathing difficulty and other breathing issues. Pulmonologists may work in hospitals to provide ventilation or life support',
    'Radiologist':
        'A radiologist specializes in diagnosing and treating conditions using medical imaging tests. They use X-rays, ultrasound, and other imaging tests to diagnose diseases. They may read and interpret scans such as X-rays, MRIs, mammograms, ultrasound, and CT scans.They may be one of three types: 1)Diagnostic radiologists: They use imaging procedures to look for health problems. 2)Interventional radiologists: They use imaging, including X-rays and MRI scans, paired with medical procedures to treat conditions such as heart disease, stroke, and cancer. 3)Radiation oncologists: They prescribe cancer treatment using radiation therapy.',
    'Rheumatologist':
        'They specialize in arthritis and other diseases in your joints, muscles, bones, and tendons. You might see them for your osteoporosis (weak bones), back pain, gout, tendinitis from sports or repetitive injuries, and fibromyalgia.',
    'Surgeon':
        'These doctors can operate on all parts of your body. They can take out tumors, appendices, or gallbladders and repair hernias. Many surgeons have subspecialties, like cancer, hand, or vascular surgery.',
    'Urologist':
        'Urologists treat conditions of the urinary tract in both males and females, for example like a leaky bladder. They also focus on male reproductive health and treat male infertility and do prostate exams.',
  };

  static Map<String, List<String>> practiceDiagnosis = {
    'Allergist /Immunologist': [
      'asthma',
      'eczema',
      'food allergies',
      'drug allergies',
      'insect sting allergies',
      'immune deficiencies',
      'autoimmune diseases',
      'diseases of the lung',
      'diseases of the respiratory tract',
      'diseases of the immune system',
      'multiple sclerosis',
      'myasthenia gravis',
      'coeliac Disease',
      'inflammatory bowel disease',
      'aplastic anemia',
      'pernicious anemia',
      'reactive arthritis',
      'rheumatoid arthritis',
      'guillain-barré syndrome',
      'sjögren syndrome',
      'systemic lupus erythematosus',
      'type 1 diabetes',
    ],
    'Anesthesiologist': [
      'administering pain relief',
      'monitoring patient\'s vital signs',
      'administering anesthesia',
    ],
    'Cardiologist': [
      'heart failure',
      'heart attack',
      'high blood pressure',
      'irregular heartbeat',
      'arrhythmias',
      'aorta disease',
      'marfan syndrome',
      'congenital heart disease',
      'coronary artery disease',
      'narrowing of the arteries',
      'deep vein thrombosis',
      'pulmonary embolism',
      'heart muscle disease',
      'cardiomyopathy',
      'high cholesterol',
      'stroke',
      'heart rhythm problems',
      'congestive heart failure',
    ],
    'Colon and Rectal Surgeon': [
      'colon cancer',
      'hemorrhoids',
      'inflammatory bowel disease',
      'irritable bowel syndrome',
      'constipation',
      'anal fissures',
      'abscess',
      'colitis',
      'polyps',
      'ulcerative colitis',
      'diverticulitis',
      'rectal bleeding',
      'abdominal discomfort',
    ],
    'Critical Care Medicine Specialist': [
      'life support',
      'invasive monitoring techniques',
      'resuscitation',
      'end of life care',
      'organ dysfunction',
      'organ failure',
    ],
    'Dentist': [
      'tooth diseases',
      'broken tooth',
      'reduce gaps between teeth',
      'braces',
      'tooth implant',
      'tooth decay',
      'misshaped tooth',
      'tooth removal',
      'tooth cavity fillings',
      'gum disease',
      'gingivitis',
      'periodontitis',
      'oral cancer examination',
      'teeth whitening',
    ],
    'Dermatologist': [
      'eczema',
      'skin cancer',
      'acne',
      'psoriasis',
      'skin problems',
      'hair problems',
      'nail problems',
      'disorders of the skin',
      'disorders of the hair',
      'disorders of the nails',
      'scars',
      'acne',
      'skin allergies',
      'adjacent mucous membranes',
      'tumors',
      'inflammatory diseases of the skin',
      'skin infectious diseases',
      'skin biopsies',
      'dermatological surgery',
      'rosacea',
      'ichthyosis',
      'vitiligo',
      'hives',
      'seborrheic dermatitis',
    ],
    'Endocrinologist': [
      'hormonal disorders',
      'hormonal problems',
      'diabetes',
      'thyroid conditions',
      'hormone imbalances',
      'infertility',
      'growth problems',
      'adrenal gland conditions',
      'osteoporosis',
      'thyroid cancer',
      'addison\'s Disease',
      'cushing\'s syndrome',
      'graves Disease',
      'hashimoto\'s thyroiditis',
      'hyperthyroidism',
      'precocious puberty',
      'hypopituitarism',
      'polycystic ovary syndrome (PCOS)',
      'multiple endocrine neoplasia 1 and 2 (MEN I and MEN II)',
    ],
    'Emergency Medicine Specialist': [
      'trauma',
      'sepsis',
      'burn',
      'acute coronary syndrome',
      'poisoning',
      'stroke',
      'acute diseases',
      'injury',
    ],
    'Family Physician': [
      'routine checkups',
      'routine screening tests',
      'minor illness treatment',
      'fever',
      'cold',
      'flu',
      'disease diagnosis',
      'diabetes',
      'hypertension',
      'headache',
    ],
    'Gastroenterologist': [
      'abdominal pain',
      'ulcers',
      'diarrhea',
      'jaundice',
      'inflammatory bowel disease',
      'constipation',
      'digestive organs cancers',
      'colonoscopy',
      'endoscopy',
      'sigmoidoscopy',
      'colon cancer diagnosis',
      'gastroesophageal reflux disease (GERD)',
      'gallstones',
      'celiac disease',
      'crohn\'s disease',
      'ulcerative colitis',
      'irritable bowel syndrome',
      'hemorrhoids',
      'diverticulitis',
      'anal fissure',
    ],
    'Geriatrician': [
      'dementia',
      'delirium',
      'sleep problems',
      'bladder control problems',
      'alzheimer\'s disease',
      'injuries from falling',
      'osteoporosis',
      'weight loss',
    ],
    'Haematologist': [
      'anemia',
      'HIV',
      'blood clots',
      'lymphoma',
      'myeloma',
      'blood cell cancers',
      'blood diseases',
      'sickle cell disease',
      'hemophilia',
      'leukemia',
      'myelofibrosis',
      'essential thrombocythemia',
      'eosinophilia',
      'mastocytosis',
      'histiocytosis',
    ],
    'Hepatologist': [
      'hepatitis a',
      'hepatitis b',
      'hepatitis c',
      'gastrointestinal bleeding',
      'portal hypertension',
      'jaundice',
      'ascites',
      'enzyme defects',
      'biliary tree diseases',
      'hydatid cyst',
      'kala-azar',
      'schistosomiasis',
      'hemochromatosis',
      'pancreatitis',
    ],
    'Hospice and Palliative Medicine Specialist': [
      'pain management',
      'acute sickness care',
    ],
    'Infectious Disease Specialist': [
      'fevers',
      'lyme disease',
      'pneumonia',
      'tuberculosis',
      'HIV',
      'AIDS',
      'herpes',
      'hepatitis b',
      'hepatitis c',
      'cellulitis',
      'influenza',
      'bacterial infections',
      'clostridium difficile',
      'surgical infections',
      'parasite infections',
      'fungi infections',
      'virus infections',
      'blastomycosis',
      'bone and joint infections',
      'urinary tract infections,',
      'heart valve infections',
      'malaria',
      'tropical diseases',
      'measles',
      'mumps',
      'rubella',
      'meningitis',
      'methicillin-resistant staphylococcus aureus (MRSA)',
      'post operative infections',
      'rheumatic fever',
      'tick-borne infections',
    ],
    'Internist': [
      'routine checkups',
      'routine screening tests',
      'minor illness treatment',
      'fever',
      'cold',
      'flu',
      'disease diagnosis',
      'diabetes',
      'hypertension',
      'headache',
    ],
    'Medical Geneticist': [
      'mitochondrial encephalopathy',
      'myoclonic epilepsy with ragged red fibers (MERRF)',
      'leber\'s hereditary optic neuropathy',
      'cry of the cat syndrome',
      'Cri du chat syndrome',
      'klinefelter syndrome',
      'turner syndrome',
      'down syndrome',
      'cystic fibrosis',
      'alpha-thalassemias',
      'beta-thalassemias',
      'thalassemia',
      'tay-sachs disease',
      'sickle cell anemia (sickle cell disease)',
      'marfan syndrome',
      'fragile X syndrome',
      'huntington\'s disease',
      'hemochromatosis',
      'cytogenetic',
      'radiologic',
      'biochemical testing',
    ],
    'Neonatologist': [
      'breathing disorders',
      'infections',
      'birth defects',
    ],
    'Nephrologist': [
      'kidney inflammation',
      'dialysis',
      'kidney diseases',
      'kidney diseases',
      'kidney cancer',
      'kidney transplant',
      'high blood pressure',
      'renal (kidney) failure',
      'diabetes',
      'kidney stones',
      'lupus',
      'hypertension',
    ],
    'Neurologist': [
      'strokes',
      'seizures',
      'brain tumors',
      'spinal tumors',
      'epilepsy',
      'parkinson\'s disease',
      'alzheimer\'s disease',
      'multiple sclerosis',
      'neuropathy',
      'migraine',
      'acute spinal cord injury',
      'amyotrophic lateral sclerosis (ALS)',
      'ataxia',
      'bell\'s palsy',
      'cerebral aneurysm',
      'brain injury',
      'brain diseases',
      'guillain-barré syndrome',
      'headache',
      'head injury',
      'hydrocephalus',
      'lumbar disk disease (herniated disk)',
      'meningitis',
      'neurocutaneous syndromes',
      'cluster headaches',
      'tension headaches',
      'migraine headaches',
      'encephalitis',
      'myasthenia gravis',
      'moyamoya disease',
      'motor stereotypes'
    ],
    'Nuclear Medicine Radiologist': [
      'scintigraphy',
      'cancer',
      'hyperthyroidism',
      'thyroid cancer',
      'lymphomas',
      'tumors',
      'bone cancer',
    ],
    'Obstetrician and Gynecologist': [
      'labor and delivery',
      'pregnancy',
      'pregnancy problems',
      'pregnancy diagnosis',
      'antenatal care',
      'postnatal care',
      'caesareans (C Sections)',
      'menopausal hormone replacement therapy',
      'female infertility',
      'bacterial vaginosis',
      'cervical cancer',
      'cervical dysplasia',
      'menopause',
      'miscarriage',
      'mullerian anomalies',
      'ovarian cancer',
      'ovarian cysts',
      'ovarian remnant syndrome',
      'premature birth',
      'sexually transmitted diseases (STD)',
      'vaginal atrophy',
      'vaginal bleeding',
      'vaginal cancer',
      'vaginal fistula',
      'yeast infection (vaginal)',
    ],
    'Oncologist': [
      'carcinoma',
      'sarcoma',
      'melanoma',
      'lymphoma',
      'leukemia',
      'chemotherapy',
      'cancer',
      'skin cancer',
      'lungs cancer',
      'breasts cancer',
      'pancreas cancer',
      'lung cancer',
      'prostate cancer',
      'colorectal cancer',
      'kidney (renal) cancer',
      'bladder cancer',
      'non-hodgkin\'s lymphoma'
    ],
    'Ophthalmologist': [
      'glaucoma',
      'macular degeneration',
      'diabetic retinopathy',
      'eye dehydration',
      'amblyopia',
      'strabismus',
      'proptosis',
      'uveitis',
      'eye tumors',
      'laser refractive surgery',
      'cataract',
      'strabismus',
      'diabetic retinopathy',
      'cataract surgery',
      'corneal transplantation',
    ],
    'Osteopath': [
      'shoulder pain',
      'elbow pain',
      'arm pain',
      'neck pain',
      'lower back pain',
      'muscles problems',
      'bones problems',
      'joints problems',
    ],
    'Otolaryngologist/ENT Specialist': [
      'nose injury',
      'ear surgery',
      'nose surgery',
      'throat surgery',
      'sinuses surgery',
      'head surgery',
      'neck surgery',
      'ear problems',
      'nose problems',
      'throat problems',
      'sinuses problems',
      'head problems',
      'neck problems',
      'cholesteatoma',
      'dysphagia (difficulty swallowing)',
      'ear infection (otitis media)',
      'gastric reflux',
      'hearing aids',
      'hearing loss',
      'hoarseness',
      'meniere\'s',
      'nosebleeds',
      'sinus problems',
      'sleep apnea',
      'snoring',
      'swimmer\'s ear (otitis externa)',
      'tinnitus (ringing in the ears)',
      'tonsils',
      'adenoid problems',
    ],
    'Pathologist': [
      'clinical laboratory tests',
      'clinical lab tests',
      'tissues examination',
      'cells examination',
      'body fluids examination',
    ],
    'Pediatrician': [
      'child problems',
      'children problems',
      'infant diseases',
      'infant health issues',
      'asthma in children',
      'allergies',
      'croup',
      'chickenpox (varicella)',
      'coughs in children',
      'colds in children',
      'ear infections in children',
      'diarrhoea in children',
      'vomiting in children',
      'fever in children',
      'food allergies in children',
      'measles',
      'mumps',
    ],
    'Physiatrist': [
      'accident recovery',
      'injury recovery',
      'trauma recovery',
      'surgical recovery',
      'pediatric rehabilitation',
    ],
    'Plastic Surgeon': [
      'craniofacial surgery',
      'hand surgery',
      'facial surgery',
      'birth defect surgery',
      'plastic surgery',
      'breast implant surgery',
      'breast removal surgery',
    ],
    'Podiatrist': [
      'foot injury',
      'ankle injury',
      'foot pain',
      'ankle pain',
      'foot problems',
      'ankle problems',
    ],
    'Psychiatrist': [
      'disease control',
      'hazard control',
      'disease prevention',
      'injury prevention',
      'disease causes',
    ],
    'Pulmonologist': [
      'asthma',
      'tuberculosis',
      'lung cancer',
      'pneumonia',
      'emphysema',
      'trouble sleeping caused by breathing difficulty',
      'breathing issues',
      'breathing difficulty',
      'chronic obstructive lung disease (COPD)',
      'interstitial lung disease',
      'occupational lung disease',
      'chronic bronchitis',
      'cystic fibrosis',
      'bronchiectasis',
      'pleural effusion',
    ],
    'Radiologist': [
      'mammograms',
      'ultrasound',
      'x-ray',
      'magnetic resonance imaging (MRI)',
      'computed tomographic scan (CT scan)',
      'positron emission tomography scan (PET scan)',
    ],
    'Rheumatologist': [
      'rheumatoid arthritis',
      'osteoarthritis',
      'gout',
      'lupus',
      'scleroderma',
      'psoriatic arthritis',
      'immune-mediated disorders',
      'tissue illnesses',
      'autoimmune diseases',
      'rheumatic diseases',
      'back pain',
      'bursitis',
      'tendinitis',
      'capsulitis',
      'neck pain',
      'fibromyalgia',
      'osteoporosis (weak bones)',
    ],
    'Surgeon': [
      'tumor surgery',
      'appendice surgery',
      'gallbladders surgery',
      'hernia repair surgery',
      'cancer surgery',
      'hand surgery',
      'vascular surgery',
      'colon and rectal surgery',
      'general surgery',
      'neurological surgery',
      'ophthalmic surgery',
      'oral and maxillofacial surgery',
      'orthopaedic surgery',
      'otolaryngology',
      'thoracic surgery',
      'ear surgery',
      'nose surgery',
      'throat surgery',
      'leg surgery',
      'arm surgery',
      'hand surgery',
    ],
    'Urologist': [
      'urinary tract infections',
      'kidney diseases',
      'kidney stones',
      'leaky bladder',
      'urinary tract problems',
      'bladder problems',
      'prostate cancer',
      'male infertility',
      'renal transplant',
      'prostate cancer',
      'bladder cancer',
      'bladder prolapse',
      'hematuria (blood in the urine)',
      'erectile dysfunction (ED)',
      'interstitial cystitis (painful bladder syndrome)',
      'overactive bladder',
      'prostatitis (swelling of the prostate gland)',
    ],
  };

  static Map<String, Map<String, dynamic>> countriesData = {
    "AD": {
      "name": "Andorra",
      "native": "Andorra",
      "phone": "376",
      "continent": "EU",
      "capital": "Andorra la Vella",
      "currency": "EUR",
      "languages": ["ca"]
    },
    "AE": {
      "name": "United Arab Emirates",
      "native": "دولة الإمارات العربية المتحدة",
      "phone": "971",
      "continent": "AS",
      "capital": "Abu Dhabi",
      "currency": "AED",
      "languages": ["ar"]
    },
    "AF": {
      "name": "Afghanistan",
      "native": "افغانستان",
      "phone": "93",
      "continent": "AS",
      "capital": "Kabul",
      "currency": "AFN",
      "languages": ["ps", "uz", "tk"]
    },
    "AG": {
      "name": "Antigua and Barbuda",
      "native": "Antigua and Barbuda",
      "phone": "1268",
      "continent": "NA",
      "capital": "Saint John's",
      "currency": "XCD",
      "languages": ["en"]
    },
    "AI": {
      "name": "Anguilla",
      "native": "Anguilla",
      "phone": "1264",
      "continent": "NA",
      "capital": "The Valley",
      "currency": "XCD",
      "languages": ["en"]
    },
    "AL": {
      "name": "Albania",
      "native": "Shqipëria",
      "phone": "355",
      "continent": "EU",
      "capital": "Tirana",
      "currency": "ALL",
      "languages": ["sq"]
    },
    "AM": {
      "name": "Armenia",
      "native": "Հայաստան",
      "phone": "374",
      "continent": "AS",
      "capital": "Yerevan",
      "currency": "AMD",
      "languages": ["hy", "ru"]
    },
    "AO": {
      "name": "Angola",
      "native": "Angola",
      "phone": "244",
      "continent": "AF",
      "capital": "Luanda",
      "currency": "AOA",
      "languages": ["pt"]
    },
    "AQ": {"name": "Antarctica", "native": "Antarctica", "phone": "672", "continent": "AN", "capital": "", "currency": "", "languages": []},
    "AR": {
      "name": "Argentina",
      "native": "Argentina",
      "phone": "54",
      "continent": "SA",
      "capital": "Buenos Aires",
      "currency": "ARS",
      "languages": ["es", "gn"]
    },
    "AS": {
      "name": "American Samoa",
      "native": "American Samoa",
      "phone": "1684",
      "continent": "OC",
      "capital": "Pago Pago",
      "currency": "USD",
      "languages": ["en", "sm"]
    },
    "AT": {
      "name": "Austria",
      "native": "Österreich",
      "phone": "43",
      "continent": "EU",
      "capital": "Vienna",
      "currency": "EUR",
      "languages": ["de"]
    },
    "AU": {
      "name": "Australia",
      "native": "Australia",
      "phone": "61",
      "continent": "OC",
      "capital": "Canberra",
      "currency": "AUD",
      "languages": ["en"]
    },
    "AW": {
      "name": "Aruba",
      "native": "Aruba",
      "phone": "297",
      "continent": "NA",
      "capital": "Oranjestad",
      "currency": "AWG",
      "languages": ["nl", "pa"]
    },
    "AX": {
      "name": "Åland",
      "native": "Åland",
      "phone": "358",
      "continent": "EU",
      "capital": "Mariehamn",
      "currency": "EUR",
      "languages": ["sv"]
    },
    "AZ": {
      "name": "Azerbaijan",
      "native": "Azərbaycan",
      "phone": "994",
      "continent": "AS",
      "capital": "Baku",
      "currency": "AZN",
      "languages": ["az"]
    },
    "BA": {
      "name": "Bosnia and Herzegovina",
      "native": "Bosna i Hercegovina",
      "phone": "387",
      "continent": "EU",
      "capital": "Sarajevo",
      "currency": "BAM",
      "languages": ["bs", "hr", "sr"]
    },
    "BB": {
      "name": "Barbados",
      "native": "Barbados",
      "phone": "1246",
      "continent": "NA",
      "capital": "Bridgetown",
      "currency": "BBD",
      "languages": ["en"]
    },
    "BD": {
      "name": "Bangladesh",
      "native": "Bangladesh",
      "phone": "880",
      "continent": "AS",
      "capital": "Dhaka",
      "currency": "BDT",
      "languages": ["bn"]
    },
    "BE": {
      "name": "Belgium",
      "native": "België",
      "phone": "32",
      "continent": "EU",
      "capital": "Brussels",
      "currency": "EUR",
      "languages": ["nl", "fr", "de"]
    },
    "BF": {
      "name": "Burkina Faso",
      "native": "Burkina Faso",
      "phone": "226",
      "continent": "AF",
      "capital": "Ouagadougou",
      "currency": "XOF",
      "languages": ["fr", "ff"]
    },
    "BG": {
      "name": "Bulgaria",
      "native": "България",
      "phone": "359",
      "continent": "EU",
      "capital": "Sofia",
      "currency": "BGN",
      "languages": ["bg"]
    },
    "BH": {
      "name": "Bahrain",
      "native": "‏البحرين",
      "phone": "973",
      "continent": "AS",
      "capital": "Manama",
      "currency": "BHD",
      "languages": ["ar"]
    },
    "BI": {
      "name": "Burundi",
      "native": "Burundi",
      "phone": "257",
      "continent": "AF",
      "capital": "Bujumbura",
      "currency": "BIF",
      "languages": ["fr", "rn"]
    },
    "BJ": {
      "name": "Benin",
      "native": "Bénin",
      "phone": "229",
      "continent": "AF",
      "capital": "Porto-Novo",
      "currency": "XOF",
      "languages": ["fr"]
    },
    "BL": {
      "name": "Saint Barthélemy",
      "native": "Saint-Barthélemy",
      "phone": "590",
      "continent": "NA",
      "capital": "Gustavia",
      "currency": "EUR",
      "languages": ["fr"]
    },
    "BM": {
      "name": "Bermuda",
      "native": "Bermuda",
      "phone": "1441",
      "continent": "NA",
      "capital": "Hamilton",
      "currency": "BMD",
      "languages": ["en"]
    },
    "BN": {
      "name": "Brunei",
      "native": "Negara Brunei Darussalam",
      "phone": "673",
      "continent": "AS",
      "capital": "Bandar Seri Begawan",
      "currency": "BND",
      "languages": ["ms"]
    },
    "BO": {
      "name": "Bolivia",
      "native": "Bolivia",
      "phone": "591",
      "continent": "SA",
      "capital": "Sucre",
      "currency": "BOB,BOV",
      "languages": ["es", "ay", "qu"]
    },
    "BQ": {
      "name": "Bonaire",
      "native": "Bonaire",
      "phone": "5997",
      "continent": "NA",
      "capital": "Kralendijk",
      "currency": "USD",
      "languages": ["nl"]
    },
    "BR": {
      "name": "Brazil",
      "native": "Brasil",
      "phone": "55",
      "continent": "SA",
      "capital": "Brasília",
      "currency": "BRL",
      "languages": ["pt"]
    },
    "BS": {
      "name": "Bahamas",
      "native": "Bahamas",
      "phone": "1242",
      "continent": "NA",
      "capital": "Nassau",
      "currency": "BSD",
      "languages": ["en"]
    },
    "BT": {
      "name": "Bhutan",
      "native": "ʼbrug-yul",
      "phone": "975",
      "continent": "AS",
      "capital": "Thimphu",
      "currency": "BTN,INR",
      "languages": ["dz"]
    },
    "BV": {
      "name": "Bouvet Island",
      "native": "Bouvetøya",
      "phone": "47",
      "continent": "AN",
      "capital": "",
      "currency": "NOK",
      "languages": ["no", "nb", "nn"]
    },
    "BW": {
      "name": "Botswana",
      "native": "Botswana",
      "phone": "267",
      "continent": "AF",
      "capital": "Gaborone",
      "currency": "BWP",
      "languages": ["en", "tn"]
    },
    "BY": {
      "name": "Belarus",
      "native": "Белару́сь",
      "phone": "375",
      "continent": "EU",
      "capital": "Minsk",
      "currency": "BYN",
      "languages": ["be", "ru"]
    },
    "BZ": {
      "name": "Belize",
      "native": "Belize",
      "phone": "501",
      "continent": "NA",
      "capital": "Belmopan",
      "currency": "BZD",
      "languages": ["en", "es"]
    },
    "CA": {
      "name": "Canada",
      "native": "Canada",
      "phone": "1",
      "continent": "NA",
      "capital": "Ottawa",
      "currency": "CAD",
      "languages": ["en", "fr"]
    },
    "CC": {
      "name": "Cocos [Keeling] Islands",
      "native": "Cocos (Keeling) Islands",
      "phone": "61",
      "continent": "AS",
      "capital": "West Island",
      "currency": "AUD",
      "languages": ["en"]
    },
    "CD": {
      "name": "Democratic Republic of the Congo",
      "native": "République démocratique du Congo",
      "phone": "243",
      "continent": "AF",
      "capital": "Kinshasa",
      "currency": "CDF",
      "languages": ["fr", "ln", "kg", "sw", "lu"]
    },
    "CF": {
      "name": "Central African Republic",
      "native": "Ködörösêse tî Bêafrîka",
      "phone": "236",
      "continent": "AF",
      "capital": "Bangui",
      "currency": "XAF",
      "languages": ["fr", "sg"]
    },
    "CG": {
      "name": "Republic of the Congo",
      "native": "République du Congo",
      "phone": "242",
      "continent": "AF",
      "capital": "Brazzaville",
      "currency": "XAF",
      "languages": ["fr", "ln"]
    },
    "CH": {
      "name": "Switzerland",
      "native": "Schweiz",
      "phone": "41",
      "continent": "EU",
      "capital": "Bern",
      "currency": "CHE,CHF,CHW",
      "languages": ["de", "fr", "it"]
    },
    "CI": {
      "name": "Ivory Coast",
      "native": "Côte d'Ivoire",
      "phone": "225",
      "continent": "AF",
      "capital": "Yamoussoukro",
      "currency": "XOF",
      "languages": ["fr"]
    },
    "CK": {
      "name": "Cook Islands",
      "native": "Cook Islands",
      "phone": "682",
      "continent": "OC",
      "capital": "Avarua",
      "currency": "NZD",
      "languages": ["en"]
    },
    "CL": {
      "name": "Chile",
      "native": "Chile",
      "phone": "56",
      "continent": "SA",
      "capital": "Santiago",
      "currency": "CLF,CLP",
      "languages": ["es"]
    },
    "CM": {
      "name": "Cameroon",
      "native": "Cameroon",
      "phone": "237",
      "continent": "AF",
      "capital": "Yaoundé",
      "currency": "XAF",
      "languages": ["en", "fr"]
    },
    "CN": {
      "name": "China",
      "native": "中国",
      "phone": "86",
      "continent": "AS",
      "capital": "Beijing",
      "currency": "CNY",
      "languages": ["zh"]
    },
    "CO": {
      "name": "Colombia",
      "native": "Colombia",
      "phone": "57",
      "continent": "SA",
      "capital": "Bogotá",
      "currency": "COP",
      "languages": ["es"]
    },
    "CR": {
      "name": "Costa Rica",
      "native": "Costa Rica",
      "phone": "506",
      "continent": "NA",
      "capital": "San José",
      "currency": "CRC",
      "languages": ["es"]
    },
    "CU": {
      "name": "Cuba",
      "native": "Cuba",
      "phone": "53",
      "continent": "NA",
      "capital": "Havana",
      "currency": "CUC,CUP",
      "languages": ["es"]
    },
    "CV": {
      "name": "Cape Verde",
      "native": "Cabo Verde",
      "phone": "238",
      "continent": "AF",
      "capital": "Praia",
      "currency": "CVE",
      "languages": ["pt"]
    },
    "CW": {
      "name": "Curacao",
      "native": "Curaçao",
      "phone": "5999",
      "continent": "NA",
      "capital": "Willemstad",
      "currency": "ANG",
      "languages": ["nl", "pa", "en"]
    },
    "CX": {
      "name": "Christmas Island",
      "native": "Christmas Island",
      "phone": "61",
      "continent": "AS",
      "capital": "Flying Fish Cove",
      "currency": "AUD",
      "languages": ["en"]
    },
    "CY": {
      "name": "Cyprus",
      "native": "Κύπρος",
      "phone": "357",
      "continent": "EU",
      "capital": "Nicosia",
      "currency": "EUR",
      "languages": ["el", "tr", "hy"]
    },
    "CZ": {
      "name": "Czech Republic",
      "native": "Česká republika",
      "phone": "420",
      "continent": "EU",
      "capital": "Prague",
      "currency": "CZK",
      "languages": ["cs", "sk"]
    },
    "DE": {
      "name": "Germany",
      "native": "Deutschland",
      "phone": "49",
      "continent": "EU",
      "capital": "Berlin",
      "currency": "EUR",
      "languages": ["de"]
    },
    "DJ": {
      "name": "Djibouti",
      "native": "Djibouti",
      "phone": "253",
      "continent": "AF",
      "capital": "Djibouti",
      "currency": "DJF",
      "languages": ["fr", "ar"]
    },
    "DK": {
      "name": "Denmark",
      "native": "Danmark",
      "phone": "45",
      "continent": "EU",
      "capital": "Copenhagen",
      "currency": "DKK",
      "languages": ["da"]
    },
    "DM": {
      "name": "Dominica",
      "native": "Dominica",
      "phone": "1767",
      "continent": "NA",
      "capital": "Roseau",
      "currency": "XCD",
      "languages": ["en"]
    },
    "DO": {
      "name": "Dominican Republic",
      "native": "República Dominicana",
      "phone": "1809,1829,1849",
      "continent": "NA",
      "capital": "Santo Domingo",
      "currency": "DOP",
      "languages": ["es"]
    },
    "DZ": {
      "name": "Algeria",
      "native": "الجزائر",
      "phone": "213",
      "continent": "AF",
      "capital": "Algiers",
      "currency": "DZD",
      "languages": ["ar"]
    },
    "EC": {
      "name": "Ecuador",
      "native": "Ecuador",
      "phone": "593",
      "continent": "SA",
      "capital": "Quito",
      "currency": "USD",
      "languages": ["es"]
    },
    "EE": {
      "name": "Estonia",
      "native": "Eesti",
      "phone": "372",
      "continent": "EU",
      "capital": "Tallinn",
      "currency": "EUR",
      "languages": ["et"]
    },
    "EG": {
      "name": "Egypt",
      "native": "مصر‎",
      "phone": "20",
      "continent": "AF",
      "capital": "Cairo",
      "currency": "EGP",
      "languages": ["ar"]
    },
    "EH": {
      "name": "Western Sahara",
      "native": "الصحراء الغربية",
      "phone": "212",
      "continent": "AF",
      "capital": "El Aaiún",
      "currency": "MAD,DZD,MRU",
      "languages": ["es"]
    },
    "ER": {
      "name": "Eritrea",
      "native": "ኤርትራ",
      "phone": "291",
      "continent": "AF",
      "capital": "Asmara",
      "currency": "ERN",
      "languages": ["ti", "ar", "en"]
    },
    "ES": {
      "name": "Spain",
      "native": "España",
      "phone": "34",
      "continent": "EU",
      "capital": "Madrid",
      "currency": "EUR",
      "languages": ["es", "eu", "ca", "gl", "oc"]
    },
    "ET": {
      "name": "Ethiopia",
      "native": "ኢትዮጵያ",
      "phone": "251",
      "continent": "AF",
      "capital": "Addis Ababa",
      "currency": "ETB",
      "languages": ["am"]
    },
    "FI": {
      "name": "Finland",
      "native": "Suomi",
      "phone": "358",
      "continent": "EU",
      "capital": "Helsinki",
      "currency": "EUR",
      "languages": ["fi", "sv"]
    },
    "FJ": {
      "name": "Fiji",
      "native": "Fiji",
      "phone": "679",
      "continent": "OC",
      "capital": "Suva",
      "currency": "FJD",
      "languages": ["en", "fj", "hi", "ur"]
    },
    "FK": {
      "name": "Falkland Islands",
      "native": "Falkland Islands",
      "phone": "500",
      "continent": "SA",
      "capital": "Stanley",
      "currency": "FKP",
      "languages": ["en"]
    },
    "FM": {
      "name": "Micronesia",
      "native": "Micronesia",
      "phone": "691",
      "continent": "OC",
      "capital": "Palikir",
      "currency": "USD",
      "languages": ["en"]
    },
    "FO": {
      "name": "Faroe Islands",
      "native": "Føroyar",
      "phone": "298",
      "continent": "EU",
      "capital": "Tórshavn",
      "currency": "DKK",
      "languages": ["fo"]
    },
    "FR": {
      "name": "France",
      "native": "France",
      "phone": "33",
      "continent": "EU",
      "capital": "Paris",
      "currency": "EUR",
      "languages": ["fr"]
    },
    "GA": {
      "name": "Gabon",
      "native": "Gabon",
      "phone": "241",
      "continent": "AF",
      "capital": "Libreville",
      "currency": "XAF",
      "languages": ["fr"]
    },
    "GB": {
      "name": "United Kingdom",
      "native": "United Kingdom",
      "phone": "44",
      "continent": "EU",
      "capital": "London",
      "currency": "GBP",
      "languages": ["en"]
    },
    "GD": {
      "name": "Grenada",
      "native": "Grenada",
      "phone": "1473",
      "continent": "NA",
      "capital": "St. George's",
      "currency": "XCD",
      "languages": ["en"]
    },
    "GE": {
      "name": "Georgia",
      "native": "საქართველო",
      "phone": "995",
      "continent": "AS",
      "capital": "Tbilisi",
      "currency": "GEL",
      "languages": ["ka"]
    },
    "GF": {
      "name": "French Guiana",
      "native": "Guyane française",
      "phone": "594",
      "continent": "SA",
      "capital": "Cayenne",
      "currency": "EUR",
      "languages": ["fr"]
    },
    "GG": {
      "name": "Guernsey",
      "native": "Guernsey",
      "phone": "44",
      "continent": "EU",
      "capital": "St. Peter Port",
      "currency": "GBP",
      "languages": ["en", "fr"]
    },
    "GH": {
      "name": "Ghana",
      "native": "Ghana",
      "phone": "233",
      "continent": "AF",
      "capital": "Accra",
      "currency": "GHS",
      "languages": ["en"]
    },
    "GI": {
      "name": "Gibraltar",
      "native": "Gibraltar",
      "phone": "350",
      "continent": "EU",
      "capital": "Gibraltar",
      "currency": "GIP",
      "languages": ["en"]
    },
    "GL": {
      "name": "Greenland",
      "native": "Kalaallit Nunaat",
      "phone": "299",
      "continent": "NA",
      "capital": "Nuuk",
      "currency": "DKK",
      "languages": ["kl"]
    },
    "GM": {
      "name": "Gambia",
      "native": "Gambia",
      "phone": "220",
      "continent": "AF",
      "capital": "Banjul",
      "currency": "GMD",
      "languages": ["en"]
    },
    "GN": {
      "name": "Guinea",
      "native": "Guinée",
      "phone": "224",
      "continent": "AF",
      "capital": "Conakry",
      "currency": "GNF",
      "languages": ["fr", "ff"]
    },
    "GP": {
      "name": "Guadeloupe",
      "native": "Guadeloupe",
      "phone": "590",
      "continent": "NA",
      "capital": "Basse-Terre",
      "currency": "EUR",
      "languages": ["fr"]
    },
    "GQ": {
      "name": "Equatorial Guinea",
      "native": "Guinea Ecuatorial",
      "phone": "240",
      "continent": "AF",
      "capital": "Malabo",
      "currency": "XAF",
      "languages": ["es", "fr"]
    },
    "GR": {
      "name": "Greece",
      "native": "Ελλάδα",
      "phone": "30",
      "continent": "EU",
      "capital": "Athens",
      "currency": "EUR",
      "languages": ["el"]
    },
    "GS": {
      "name": "South Georgia and the South Sandwich Islands",
      "native": "South Georgia",
      "phone": "500",
      "continent": "AN",
      "capital": "King Edward Point",
      "currency": "GBP",
      "languages": ["en"]
    },
    "GT": {
      "name": "Guatemala",
      "native": "Guatemala",
      "phone": "502",
      "continent": "NA",
      "capital": "Guatemala City",
      "currency": "GTQ",
      "languages": ["es"]
    },
    "GU": {
      "name": "Guam",
      "native": "Guam",
      "phone": "1671",
      "continent": "OC",
      "capital": "Hagåtña",
      "currency": "USD",
      "languages": ["en", "ch", "es"]
    },
    "GW": {
      "name": "Guinea-Bissau",
      "native": "Guiné-Bissau",
      "phone": "245",
      "continent": "AF",
      "capital": "Bissau",
      "currency": "XOF",
      "languages": ["pt"]
    },
    "GY": {
      "name": "Guyana",
      "native": "Guyana",
      "phone": "592",
      "continent": "SA",
      "capital": "Georgetown",
      "currency": "GYD",
      "languages": ["en"]
    },
    "HK": {
      "name": "Hong Kong",
      "native": "香港",
      "phone": "852",
      "continent": "AS",
      "capital": "City of Victoria",
      "currency": "HKD",
      "languages": ["zh", "en"]
    },
    "HM": {
      "name": "Heard Island and McDonald Islands",
      "native": "Heard Island and McDonald Islands",
      "phone": "61",
      "continent": "AN",
      "capital": "",
      "currency": "AUD",
      "languages": ["en"]
    },
    "HN": {
      "name": "Honduras",
      "native": "Honduras",
      "phone": "504",
      "continent": "NA",
      "capital": "Tegucigalpa",
      "currency": "HNL",
      "languages": ["es"]
    },
    "HR": {
      "name": "Croatia",
      "native": "Hrvatska",
      "phone": "385",
      "continent": "EU",
      "capital": "Zagreb",
      "currency": "HRK",
      "languages": ["hr"]
    },
    "HT": {
      "name": "Haiti",
      "native": "Haïti",
      "phone": "509",
      "continent": "NA",
      "capital": "Port-au-Prince",
      "currency": "HTG,USD",
      "languages": ["fr", "ht"]
    },
    "HU": {
      "name": "Hungary",
      "native": "Magyarország",
      "phone": "36",
      "continent": "EU",
      "capital": "Budapest",
      "currency": "HUF",
      "languages": ["hu"]
    },
    "ID": {
      "name": "Indonesia",
      "native": "Indonesia",
      "phone": "62",
      "continent": "AS",
      "capital": "Jakarta",
      "currency": "IDR",
      "languages": ["id"]
    },
    "IE": {
      "name": "Ireland",
      "native": "Éire",
      "phone": "353",
      "continent": "EU",
      "capital": "Dublin",
      "currency": "EUR",
      "languages": ["ga", "en"]
    },
    "IL": {
      "name": "Israel",
      "native": "יִשְׂרָאֵל",
      "phone": "972",
      "continent": "AS",
      "capital": "Jerusalem",
      "currency": "ILS",
      "languages": ["he", "ar"]
    },
    "IM": {
      "name": "Isle of Man",
      "native": "Isle of Man",
      "phone": "44",
      "continent": "EU",
      "capital": "Douglas",
      "currency": "GBP",
      "languages": ["en", "gv"]
    },
    "IN": {
      "name": "India",
      "native": "भारत",
      "phone": "91",
      "continent": "AS",
      "capital": "New Delhi",
      "currency": "INR",
      "languages": ["hi", "en"]
    },
    "IO": {
      "name": "British Indian Ocean Territory",
      "native": "British Indian Ocean Territory",
      "phone": "246",
      "continent": "AS",
      "capital": "Diego Garcia",
      "currency": "USD",
      "languages": ["en"]
    },
    "IQ": {
      "name": "Iraq",
      "native": "العراق",
      "phone": "964",
      "continent": "AS",
      "capital": "Baghdad",
      "currency": "IQD",
      "languages": ["ar", "ku"]
    },
    "IR": {
      "name": "Iran",
      "native": "ایران",
      "phone": "98",
      "continent": "AS",
      "capital": "Tehran",
      "currency": "IRR",
      "languages": ["fa"]
    },
    "IS": {
      "name": "Iceland",
      "native": "Ísland",
      "phone": "354",
      "continent": "EU",
      "capital": "Reykjavik",
      "currency": "ISK",
      "languages": ["is"]
    },
    "IT": {
      "name": "Italy",
      "native": "Italia",
      "phone": "39",
      "continent": "EU",
      "capital": "Rome",
      "currency": "EUR",
      "languages": ["it"]
    },
    "JE": {
      "name": "Jersey",
      "native": "Jersey",
      "phone": "44",
      "continent": "EU",
      "capital": "Saint Helier",
      "currency": "GBP",
      "languages": ["en", "fr"]
    },
    "JM": {
      "name": "Jamaica",
      "native": "Jamaica",
      "phone": "1876",
      "continent": "NA",
      "capital": "Kingston",
      "currency": "JMD",
      "languages": ["en"]
    },
    "JO": {
      "name": "Jordan",
      "native": "الأردن",
      "phone": "962",
      "continent": "AS",
      "capital": "Amman",
      "currency": "JOD",
      "languages": ["ar"]
    },
    "JP": {
      "name": "Japan",
      "native": "日本",
      "phone": "81",
      "continent": "AS",
      "capital": "Tokyo",
      "currency": "JPY",
      "languages": ["ja"]
    },
    "KE": {
      "name": "Kenya",
      "native": "Kenya",
      "phone": "254",
      "continent": "AF",
      "capital": "Nairobi",
      "currency": "KES",
      "languages": ["en", "sw"]
    },
    "KG": {
      "name": "Kyrgyzstan",
      "native": "Кыргызстан",
      "phone": "996",
      "continent": "AS",
      "capital": "Bishkek",
      "currency": "KGS",
      "languages": ["ky", "ru"]
    },
    "KH": {
      "name": "Cambodia",
      "native": "Kâmpŭchéa",
      "phone": "855",
      "continent": "AS",
      "capital": "Phnom Penh",
      "currency": "KHR",
      "languages": ["km"]
    },
    "KI": {
      "name": "Kiribati",
      "native": "Kiribati",
      "phone": "686",
      "continent": "OC",
      "capital": "South Tarawa",
      "currency": "AUD",
      "languages": ["en"]
    },
    "KM": {
      "name": "Comoros",
      "native": "Komori",
      "phone": "269",
      "continent": "AF",
      "capital": "Moroni",
      "currency": "KMF",
      "languages": ["ar", "fr"]
    },
    "KN": {
      "name": "Saint Kitts and Nevis",
      "native": "Saint Kitts and Nevis",
      "phone": "1869",
      "continent": "NA",
      "capital": "Basseterre",
      "currency": "XCD",
      "languages": ["en"]
    },
    "KP": {
      "name": "North Korea",
      "native": "북한",
      "phone": "850",
      "continent": "AS",
      "capital": "Pyongyang",
      "currency": "KPW",
      "languages": ["ko"]
    },
    "KR": {
      "name": "South Korea",
      "native": "대한민국",
      "phone": "82",
      "continent": "AS",
      "capital": "Seoul",
      "currency": "KRW",
      "languages": ["ko"]
    },
    "KW": {
      "name": "Kuwait",
      "native": "الكويت",
      "phone": "965",
      "continent": "AS",
      "capital": "Kuwait City",
      "currency": "KWD",
      "languages": ["ar"]
    },
    "KY": {
      "name": "Cayman Islands",
      "native": "Cayman Islands",
      "phone": "1345",
      "continent": "NA",
      "capital": "George Town",
      "currency": "KYD",
      "languages": ["en"]
    },
    "KZ": {
      "name": "Kazakhstan",
      "native": "Қазақстан",
      "phone": "76,77",
      "continent": "AS",
      "capital": "Astana",
      "currency": "KZT",
      "languages": ["kk", "ru"]
    },
    "LA": {
      "name": "Laos",
      "native": "ສປປລາວ",
      "phone": "856",
      "continent": "AS",
      "capital": "Vientiane",
      "currency": "LAK",
      "languages": ["lo"]
    },
    "LB": {
      "name": "Lebanon",
      "native": "لبنان",
      "phone": "961",
      "continent": "AS",
      "capital": "Beirut",
      "currency": "LBP",
      "languages": ["ar", "fr"]
    },
    "LC": {
      "name": "Saint Lucia",
      "native": "Saint Lucia",
      "phone": "1758",
      "continent": "NA",
      "capital": "Castries",
      "currency": "XCD",
      "languages": ["en"]
    },
    "LI": {
      "name": "Liechtenstein",
      "native": "Liechtenstein",
      "phone": "423",
      "continent": "EU",
      "capital": "Vaduz",
      "currency": "CHF",
      "languages": ["de"]
    },
    "LK": {
      "name": "Sri Lanka",
      "native": "śrī laṃkāva",
      "phone": "94",
      "continent": "AS",
      "capital": "Colombo",
      "currency": "LKR",
      "languages": ["si", "ta"]
    },
    "LR": {
      "name": "Liberia",
      "native": "Liberia",
      "phone": "231",
      "continent": "AF",
      "capital": "Monrovia",
      "currency": "LRD",
      "languages": ["en"]
    },
    "LS": {
      "name": "Lesotho",
      "native": "Lesotho",
      "phone": "266",
      "continent": "AF",
      "capital": "Maseru",
      "currency": "LSL,ZAR",
      "languages": ["en", "st"]
    },
    "LT": {
      "name": "Lithuania",
      "native": "Lietuva",
      "phone": "370",
      "continent": "EU",
      "capital": "Vilnius",
      "currency": "EUR",
      "languages": ["lt"]
    },
    "LU": {
      "name": "Luxembourg",
      "native": "Luxembourg",
      "phone": "352",
      "continent": "EU",
      "capital": "Luxembourg",
      "currency": "EUR",
      "languages": ["fr", "de", "lb"]
    },
    "LV": {
      "name": "Latvia",
      "native": "Latvija",
      "phone": "371",
      "continent": "EU",
      "capital": "Riga",
      "currency": "EUR",
      "languages": ["lv"]
    },
    "LY": {
      "name": "Libya",
      "native": "‏ليبيا",
      "phone": "218",
      "continent": "AF",
      "capital": "Tripoli",
      "currency": "LYD",
      "languages": ["ar"]
    },
    "MA": {
      "name": "Morocco",
      "native": "المغرب",
      "phone": "212",
      "continent": "AF",
      "capital": "Rabat",
      "currency": "MAD",
      "languages": ["ar"]
    },
    "MC": {
      "name": "Monaco",
      "native": "Monaco",
      "phone": "377",
      "continent": "EU",
      "capital": "Monaco",
      "currency": "EUR",
      "languages": ["fr"]
    },
    "MD": {
      "name": "Moldova",
      "native": "Moldova",
      "phone": "373",
      "continent": "EU",
      "capital": "Chișinău",
      "currency": "MDL",
      "languages": ["ro"]
    },
    "ME": {
      "name": "Montenegro",
      "native": "Црна Гора",
      "phone": "382",
      "continent": "EU",
      "capital": "Podgorica",
      "currency": "EUR",
      "languages": ["sr", "bs", "sq", "hr"]
    },
    "MF": {
      "name": "Saint Martin",
      "native": "Saint-Martin",
      "phone": "590",
      "continent": "NA",
      "capital": "Marigot",
      "currency": "EUR",
      "languages": ["en", "fr", "nl"]
    },
    "MG": {
      "name": "Madagascar",
      "native": "Madagasikara",
      "phone": "261",
      "continent": "AF",
      "capital": "Antananarivo",
      "currency": "MGA",
      "languages": ["fr", "mg"]
    },
    "MH": {
      "name": "Marshall Islands",
      "native": "M̧ajeļ",
      "phone": "692",
      "continent": "OC",
      "capital": "Majuro",
      "currency": "USD",
      "languages": ["en", "mh"]
    },
    "MK": {
      "name": "North Macedonia",
      "native": "Северна Македонија",
      "phone": "389",
      "continent": "EU",
      "capital": "Skopje",
      "currency": "MKD",
      "languages": ["mk"]
    },
    "ML": {
      "name": "Mali",
      "native": "Mali",
      "phone": "223",
      "continent": "AF",
      "capital": "Bamako",
      "currency": "XOF",
      "languages": ["fr"]
    },
    "MM": {
      "name": "Myanmar [Burma]",
      "native": "မြန်မာ",
      "phone": "95",
      "continent": "AS",
      "capital": "Naypyidaw",
      "currency": "MMK",
      "languages": ["my"]
    },
    "MN": {
      "name": "Mongolia",
      "native": "Монгол улс",
      "phone": "976",
      "continent": "AS",
      "capital": "Ulan Bator",
      "currency": "MNT",
      "languages": ["mn"]
    },
    "MO": {
      "name": "Macao",
      "native": "澳門",
      "phone": "853",
      "continent": "AS",
      "capital": "",
      "currency": "MOP",
      "languages": ["zh", "pt"]
    },
    "MP": {
      "name": "Northern Mariana Islands",
      "native": "Northern Mariana Islands",
      "phone": "1670",
      "continent": "OC",
      "capital": "Saipan",
      "currency": "USD",
      "languages": ["en", "ch"]
    },
    "MQ": {
      "name": "Martinique",
      "native": "Martinique",
      "phone": "596",
      "continent": "NA",
      "capital": "Fort-de-France",
      "currency": "EUR",
      "languages": ["fr"]
    },
    "MR": {
      "name": "Mauritania",
      "native": "موريتانيا",
      "phone": "222",
      "continent": "AF",
      "capital": "Nouakchott",
      "currency": "MRU",
      "languages": ["ar"]
    },
    "MS": {
      "name": "Montserrat",
      "native": "Montserrat",
      "phone": "1664",
      "continent": "NA",
      "capital": "Plymouth",
      "currency": "XCD",
      "languages": ["en"]
    },
    "MT": {
      "name": "Malta",
      "native": "Malta",
      "phone": "356",
      "continent": "EU",
      "capital": "Valletta",
      "currency": "EUR",
      "languages": ["mt", "en"]
    },
    "MU": {
      "name": "Mauritius",
      "native": "Maurice",
      "phone": "230",
      "continent": "AF",
      "capital": "Port Louis",
      "currency": "MUR",
      "languages": ["en"]
    },
    "MV": {
      "name": "Maldives",
      "native": "Maldives",
      "phone": "960",
      "continent": "AS",
      "capital": "Malé",
      "currency": "MVR",
      "languages": ["dv"]
    },
    "MW": {
      "name": "Malawi",
      "native": "Malawi",
      "phone": "265",
      "continent": "AF",
      "capital": "Lilongwe",
      "currency": "MWK",
      "languages": ["en", "ny"]
    },
    "MX": {
      "name": "Mexico",
      "native": "México",
      "phone": "52",
      "continent": "NA",
      "capital": "Mexico City",
      "currency": "MXN",
      "languages": ["es"]
    },
    "MY": {
      "name": "Malaysia",
      "native": "Malaysia",
      "phone": "60",
      "continent": "AS",
      "capital": "Kuala Lumpur",
      "currency": "MYR",
      "languages": ["ms"]
    },
    "MZ": {
      "name": "Mozambique",
      "native": "Moçambique",
      "phone": "258",
      "continent": "AF",
      "capital": "Maputo",
      "currency": "MZN",
      "languages": ["pt"]
    },
    "NA": {
      "name": "Namibia",
      "native": "Namibia",
      "phone": "264",
      "continent": "AF",
      "capital": "Windhoek",
      "currency": "NAD,ZAR",
      "languages": ["en", "af"]
    },
    "NC": {
      "name": "New Caledonia",
      "native": "Nouvelle-Calédonie",
      "phone": "687",
      "continent": "OC",
      "capital": "Nouméa",
      "currency": "XPF",
      "languages": ["fr"]
    },
    "NE": {
      "name": "Niger",
      "native": "Niger",
      "phone": "227",
      "continent": "AF",
      "capital": "Niamey",
      "currency": "XOF",
      "languages": ["fr"]
    },
    "NF": {
      "name": "Norfolk Island",
      "native": "Norfolk Island",
      "phone": "672",
      "continent": "OC",
      "capital": "Kingston",
      "currency": "AUD",
      "languages": ["en"]
    },
    "NG": {
      "name": "Nigeria",
      "native": "Nigeria",
      "phone": "234",
      "continent": "AF",
      "capital": "Abuja",
      "currency": "NGN",
      "languages": ["en"]
    },
    "NI": {
      "name": "Nicaragua",
      "native": "Nicaragua",
      "phone": "505",
      "continent": "NA",
      "capital": "Managua",
      "currency": "NIO",
      "languages": ["es"]
    },
    "NL": {
      "name": "Netherlands",
      "native": "Nederland",
      "phone": "31",
      "continent": "EU",
      "capital": "Amsterdam",
      "currency": "EUR",
      "languages": ["nl"]
    },
    "NO": {
      "name": "Norway",
      "native": "Norge",
      "phone": "47",
      "continent": "EU",
      "capital": "Oslo",
      "currency": "NOK",
      "languages": ["no", "nb", "nn"]
    },
    "NP": {
      "name": "Nepal",
      "native": "नपल",
      "phone": "977",
      "continent": "AS",
      "capital": "Kathmandu",
      "currency": "NPR",
      "languages": ["ne"]
    },
    "NR": {
      "name": "Nauru",
      "native": "Nauru",
      "phone": "674",
      "continent": "OC",
      "capital": "Yaren",
      "currency": "AUD",
      "languages": ["en", "na"]
    },
    "NU": {
      "name": "Niue",
      "native": "Niuē",
      "phone": "683",
      "continent": "OC",
      "capital": "Alofi",
      "currency": "NZD",
      "languages": ["en"]
    },
    "NZ": {
      "name": "New Zealand",
      "native": "New Zealand",
      "phone": "64",
      "continent": "OC",
      "capital": "Wellington",
      "currency": "NZD",
      "languages": ["en", "mi"]
    },
    "OM": {
      "name": "Oman",
      "native": "عمان",
      "phone": "968",
      "continent": "AS",
      "capital": "Muscat",
      "currency": "OMR",
      "languages": ["ar"]
    },
    "PA": {
      "name": "Panama",
      "native": "Panamá",
      "phone": "507",
      "continent": "NA",
      "capital": "Panama City",
      "currency": "PAB,USD",
      "languages": ["es"]
    },
    "PE": {
      "name": "Peru",
      "native": "Perú",
      "phone": "51",
      "continent": "SA",
      "capital": "Lima",
      "currency": "PEN",
      "languages": ["es"]
    },
    "PF": {
      "name": "French Polynesia",
      "native": "Polynésie française",
      "phone": "689",
      "continent": "OC",
      "capital": "Papeetē",
      "currency": "XPF",
      "languages": ["fr"]
    },
    "PG": {
      "name": "Papua New Guinea",
      "native": "Papua Niugini",
      "phone": "675",
      "continent": "OC",
      "capital": "Port Moresby",
      "currency": "PGK",
      "languages": ["en"]
    },
    "PH": {
      "name": "Philippines",
      "native": "Pilipinas",
      "phone": "63",
      "continent": "AS",
      "capital": "Manila",
      "currency": "PHP",
      "languages": ["en"]
    },
    "PK": {
      "name": "Pakistan",
      "native": "Pakistan",
      "phone": "92",
      "continent": "AS",
      "capital": "Islamabad",
      "currency": "PKR",
      "languages": ["en", "ur"]
    },
    "PL": {
      "name": "Poland",
      "native": "Polska",
      "phone": "48",
      "continent": "EU",
      "capital": "Warsaw",
      "currency": "PLN",
      "languages": ["pl"]
    },
    "PM": {
      "name": "Saint Pierre and Miquelon",
      "native": "Saint-Pierre-et-Miquelon",
      "phone": "508",
      "continent": "NA",
      "capital": "Saint-Pierre",
      "currency": "EUR",
      "languages": ["fr"]
    },
    "PN": {
      "name": "Pitcairn Islands",
      "native": "Pitcairn Islands",
      "phone": "64",
      "continent": "OC",
      "capital": "Adamstown",
      "currency": "NZD",
      "languages": ["en"]
    },
    "PR": {
      "name": "Puerto Rico",
      "native": "Puerto Rico",
      "phone": "1787,1939",
      "continent": "NA",
      "capital": "San Juan",
      "currency": "USD",
      "languages": ["es", "en"]
    },
    "PS": {
      "name": "Palestine",
      "native": "فلسطين",
      "phone": "970",
      "continent": "AS",
      "capital": "Ramallah",
      "currency": "ILS",
      "languages": ["ar"]
    },
    "PT": {
      "name": "Portugal",
      "native": "Portugal",
      "phone": "351",
      "continent": "EU",
      "capital": "Lisbon",
      "currency": "EUR",
      "languages": ["pt"]
    },
    "PW": {
      "name": "Palau",
      "native": "Palau",
      "phone": "680",
      "continent": "OC",
      "capital": "Ngerulmud",
      "currency": "USD",
      "languages": ["en"]
    },
    "PY": {
      "name": "Paraguay",
      "native": "Paraguay",
      "phone": "595",
      "continent": "SA",
      "capital": "Asunción",
      "currency": "PYG",
      "languages": ["es", "gn"]
    },
    "QA": {
      "name": "Qatar",
      "native": "قطر",
      "phone": "974",
      "continent": "AS",
      "capital": "Doha",
      "currency": "QAR",
      "languages": ["ar"]
    },
    "RE": {
      "name": "Réunion",
      "native": "La Réunion",
      "phone": "262",
      "continent": "AF",
      "capital": "Saint-Denis",
      "currency": "EUR",
      "languages": ["fr"]
    },
    "RO": {
      "name": "Romania",
      "native": "România",
      "phone": "40",
      "continent": "EU",
      "capital": "Bucharest",
      "currency": "RON",
      "languages": ["ro"]
    },
    "RS": {
      "name": "Serbia",
      "native": "Србија",
      "phone": "381",
      "continent": "EU",
      "capital": "Belgrade",
      "currency": "RSD",
      "languages": ["sr"]
    },
    "RU": {
      "name": "Russia",
      "native": "Россия",
      "phone": "7",
      "continent": "EU",
      "capital": "Moscow",
      "currency": "RUB",
      "languages": ["ru"]
    },
    "RW": {
      "name": "Rwanda",
      "native": "Rwanda",
      "phone": "250",
      "continent": "AF",
      "capital": "Kigali",
      "currency": "RWF",
      "languages": ["rw", "en", "fr"]
    },
    "SA": {
      "name": "Saudi Arabia",
      "native": "العربية السعودية",
      "phone": "966",
      "continent": "AS",
      "capital": "Riyadh",
      "currency": "SAR",
      "languages": ["ar"]
    },
    "SB": {
      "name": "Solomon Islands",
      "native": "Solomon Islands",
      "phone": "677",
      "continent": "OC",
      "capital": "Honiara",
      "currency": "SBD",
      "languages": ["en"]
    },
    "SC": {
      "name": "Seychelles",
      "native": "Seychelles",
      "phone": "248",
      "continent": "AF",
      "capital": "Victoria",
      "currency": "SCR",
      "languages": ["fr", "en"]
    },
    "SD": {
      "name": "Sudan",
      "native": "السودان",
      "phone": "249",
      "continent": "AF",
      "capital": "Khartoum",
      "currency": "SDG",
      "languages": ["ar", "en"]
    },
    "SE": {
      "name": "Sweden",
      "native": "Sverige",
      "phone": "46",
      "continent": "EU",
      "capital": "Stockholm",
      "currency": "SEK",
      "languages": ["sv"]
    },
    "SG": {
      "name": "Singapore",
      "native": "Singapore",
      "phone": "65",
      "continent": "AS",
      "capital": "Singapore",
      "currency": "SGD",
      "languages": ["en", "ms", "ta", "zh"]
    },
    "SH": {
      "name": "Saint Helena",
      "native": "Saint Helena",
      "phone": "290",
      "continent": "AF",
      "capital": "Jamestown",
      "currency": "SHP",
      "languages": ["en"]
    },
    "SI": {
      "name": "Slovenia",
      "native": "Slovenija",
      "phone": "386",
      "continent": "EU",
      "capital": "Ljubljana",
      "currency": "EUR",
      "languages": ["sl"]
    },
    "SJ": {
      "name": "Svalbard and Jan Mayen",
      "native": "Svalbard og Jan Mayen",
      "phone": "4779",
      "continent": "EU",
      "capital": "Longyearbyen",
      "currency": "NOK",
      "languages": ["no"]
    },
    "SK": {
      "name": "Slovakia",
      "native": "Slovensko",
      "phone": "421",
      "continent": "EU",
      "capital": "Bratislava",
      "currency": "EUR",
      "languages": ["sk"]
    },
    "SL": {
      "name": "Sierra Leone",
      "native": "Sierra Leone",
      "phone": "232",
      "continent": "AF",
      "capital": "Freetown",
      "currency": "SLL",
      "languages": ["en"]
    },
    "SM": {
      "name": "San Marino",
      "native": "San Marino",
      "phone": "378",
      "continent": "EU",
      "capital": "City of San Marino",
      "currency": "EUR",
      "languages": ["it"]
    },
    "SN": {
      "name": "Senegal",
      "native": "Sénégal",
      "phone": "221",
      "continent": "AF",
      "capital": "Dakar",
      "currency": "XOF",
      "languages": ["fr"]
    },
    "SO": {
      "name": "Somalia",
      "native": "Soomaaliya",
      "phone": "252",
      "continent": "AF",
      "capital": "Mogadishu",
      "currency": "SOS",
      "languages": ["so", "ar"]
    },
    "SR": {
      "name": "Suriname",
      "native": "Suriname",
      "phone": "597",
      "continent": "SA",
      "capital": "Paramaribo",
      "currency": "SRD",
      "languages": ["nl"]
    },
    "SS": {
      "name": "South Sudan",
      "native": "South Sudan",
      "phone": "211",
      "continent": "AF",
      "capital": "Juba",
      "currency": "SSP",
      "languages": ["en"]
    },
    "ST": {
      "name": "São Tomé and Príncipe",
      "native": "São Tomé e Príncipe",
      "phone": "239",
      "continent": "AF",
      "capital": "São Tomé",
      "currency": "STN",
      "languages": ["pt"]
    },
    "SV": {
      "name": "El Salvador",
      "native": "El Salvador",
      "phone": "503",
      "continent": "NA",
      "capital": "San Salvador",
      "currency": "SVC,USD",
      "languages": ["es"]
    },
    "SX": {
      "name": "Sint Maarten",
      "native": "Sint Maarten",
      "phone": "1721",
      "continent": "NA",
      "capital": "Philipsburg",
      "currency": "ANG",
      "languages": ["nl", "en"]
    },
    "SY": {
      "name": "Syria",
      "native": "سوريا",
      "phone": "963",
      "continent": "AS",
      "capital": "Damascus",
      "currency": "SYP",
      "languages": ["ar"]
    },
    "SZ": {
      "name": "Swaziland",
      "native": "Swaziland",
      "phone": "268",
      "continent": "AF",
      "capital": "Lobamba",
      "currency": "SZL",
      "languages": ["en", "ss"]
    },
    "TC": {
      "name": "Turks and Caicos Islands",
      "native": "Turks and Caicos Islands",
      "phone": "1649",
      "continent": "NA",
      "capital": "Cockburn Town",
      "currency": "USD",
      "languages": ["en"]
    },
    "TD": {
      "name": "Chad",
      "native": "Tchad",
      "phone": "235",
      "continent": "AF",
      "capital": "N'Djamena",
      "currency": "XAF",
      "languages": ["fr", "ar"]
    },
    "TF": {
      "name": "French Southern Territories",
      "native": "Territoire des Terres australes et antarctiques fr",
      "phone": "262",
      "continent": "AN",
      "capital": "Port-aux-Français",
      "currency": "EUR",
      "languages": ["fr"]
    },
    "TG": {
      "name": "Togo",
      "native": "Togo",
      "phone": "228",
      "continent": "AF",
      "capital": "Lomé",
      "currency": "XOF",
      "languages": ["fr"]
    },
    "TH": {
      "name": "Thailand",
      "native": "ประเทศไทย",
      "phone": "66",
      "continent": "AS",
      "capital": "Bangkok",
      "currency": "THB",
      "languages": ["th"]
    },
    "TJ": {
      "name": "Tajikistan",
      "native": "Тоҷикистон",
      "phone": "992",
      "continent": "AS",
      "capital": "Dushanbe",
      "currency": "TJS",
      "languages": ["tg", "ru"]
    },
    "TK": {
      "name": "Tokelau",
      "native": "Tokelau",
      "phone": "690",
      "continent": "OC",
      "capital": "Fakaofo",
      "currency": "NZD",
      "languages": ["en"]
    },
    "TL": {
      "name": "East Timor",
      "native": "Timor-Leste",
      "phone": "670",
      "continent": "OC",
      "capital": "Dili",
      "currency": "USD",
      "languages": ["pt"]
    },
    "TM": {
      "name": "Turkmenistan",
      "native": "Türkmenistan",
      "phone": "993",
      "continent": "AS",
      "capital": "Ashgabat",
      "currency": "TMT",
      "languages": ["tk", "ru"]
    },
    "TN": {
      "name": "Tunisia",
      "native": "تونس",
      "phone": "216",
      "continent": "AF",
      "capital": "Tunis",
      "currency": "TND",
      "languages": ["ar"]
    },
    "TO": {
      "name": "Tonga",
      "native": "Tonga",
      "phone": "676",
      "continent": "OC",
      "capital": "Nuku'alofa",
      "currency": "TOP",
      "languages": ["en", "to"]
    },
    "TR": {
      "name": "Turkey",
      "native": "Türkiye",
      "phone": "90",
      "continent": "AS",
      "capital": "Ankara",
      "currency": "TRY",
      "languages": ["tr"]
    },
    "TT": {
      "name": "Trinidad and Tobago",
      "native": "Trinidad and Tobago",
      "phone": "1868",
      "continent": "NA",
      "capital": "Port of Spain",
      "currency": "TTD",
      "languages": ["en"]
    },
    "TV": {
      "name": "Tuvalu",
      "native": "Tuvalu",
      "phone": "688",
      "continent": "OC",
      "capital": "Funafuti",
      "currency": "AUD",
      "languages": ["en"]
    },
    "TW": {
      "name": "Taiwan",
      "native": "臺灣",
      "phone": "886",
      "continent": "AS",
      "capital": "Taipei",
      "currency": "TWD",
      "languages": ["zh"]
    },
    "TZ": {
      "name": "Tanzania",
      "native": "Tanzania",
      "phone": "255",
      "continent": "AF",
      "capital": "Dodoma",
      "currency": "TZS",
      "languages": ["sw", "en"]
    },
    "UA": {
      "name": "Ukraine",
      "native": "Україна",
      "phone": "380",
      "continent": "EU",
      "capital": "Kyiv",
      "currency": "UAH",
      "languages": ["uk"]
    },
    "UG": {
      "name": "Uganda",
      "native": "Uganda",
      "phone": "256",
      "continent": "AF",
      "capital": "Kampala",
      "currency": "UGX",
      "languages": ["en", "sw"]
    },
    "UM": {
      "name": "U.S. Minor Outlying Islands",
      "native": "United States Minor Outlying Islands",
      "phone": "1",
      "continent": "OC",
      "capital": "",
      "currency": "USD",
      "languages": ["en"]
    },
    "US": {
      "name": "United States",
      "native": "United States",
      "phone": "1",
      "continent": "NA",
      "capital": "Washington D.C.",
      "currency": "USD,USN,USS",
      "languages": ["en"]
    },
    "UY": {
      "name": "Uruguay",
      "native": "Uruguay",
      "phone": "598",
      "continent": "SA",
      "capital": "Montevideo",
      "currency": "UYI,UYU",
      "languages": ["es"]
    },
    "UZ": {
      "name": "Uzbekistan",
      "native": "O‘zbekiston",
      "phone": "998",
      "continent": "AS",
      "capital": "Tashkent",
      "currency": "UZS",
      "languages": ["uz", "ru"]
    },
    "VA": {
      "name": "Vatican City",
      "native": "Vaticano",
      "phone": "379",
      "continent": "EU",
      "capital": "Vatican City",
      "currency": "EUR",
      "languages": ["it", "la"]
    },
    "VC": {
      "name": "Saint Vincent and the Grenadines",
      "native": "Saint Vincent and the Grenadines",
      "phone": "1784",
      "continent": "NA",
      "capital": "Kingstown",
      "currency": "XCD",
      "languages": ["en"]
    },
    "VE": {
      "name": "Venezuela",
      "native": "Venezuela",
      "phone": "58",
      "continent": "SA",
      "capital": "Caracas",
      "currency": "VES",
      "languages": ["es"]
    },
    "VG": {
      "name": "British Virgin Islands",
      "native": "British Virgin Islands",
      "phone": "1284",
      "continent": "NA",
      "capital": "Road Town",
      "currency": "USD",
      "languages": ["en"]
    },
    "VI": {
      "name": "U.S. Virgin Islands",
      "native": "United States Virgin Islands",
      "phone": "1340",
      "continent": "NA",
      "capital": "Charlotte Amalie",
      "currency": "USD",
      "languages": ["en"]
    },
    "VN": {
      "name": "Vietnam",
      "native": "Việt Nam",
      "phone": "84",
      "continent": "AS",
      "capital": "Hanoi",
      "currency": "VND",
      "languages": ["vi"]
    },
    "VU": {
      "name": "Vanuatu",
      "native": "Vanuatu",
      "phone": "678",
      "continent": "OC",
      "capital": "Port Vila",
      "currency": "VUV",
      "languages": ["bi", "en", "fr"]
    },
    "WF": {
      "name": "Wallis and Futuna",
      "native": "Wallis et Futuna",
      "phone": "681",
      "continent": "OC",
      "capital": "Mata-Utu",
      "currency": "XPF",
      "languages": ["fr"]
    },
    "WS": {
      "name": "Samoa",
      "native": "Samoa",
      "phone": "685",
      "continent": "OC",
      "capital": "Apia",
      "currency": "WST",
      "languages": ["sm", "en"]
    },
    "XK": {
      "name": "Kosovo",
      "native": "Republika e Kosovës",
      "phone": "377,381,383,386",
      "continent": "EU",
      "capital": "Pristina",
      "currency": "EUR",
      "languages": ["sq", "sr"]
    },
    "YE": {
      "name": "Yemen",
      "native": "اليَمَن",
      "phone": "967",
      "continent": "AS",
      "capital": "Sana'a",
      "currency": "YER",
      "languages": ["ar"]
    },
    "YT": {
      "name": "Mayotte",
      "native": "Mayotte",
      "phone": "262",
      "continent": "AF",
      "capital": "Mamoudzou",
      "currency": "EUR",
      "languages": ["fr"]
    },
    "ZA": {
      "name": "South Africa",
      "native": "South Africa",
      "phone": "27",
      "continent": "AF",
      "capital": "Pretoria",
      "currency": "ZAR",
      "languages": ["af", "en", "nr", "st", "ss", "tn", "ts", "ve", "xh", "zu"]
    },
    "ZM": {
      "name": "Zambia",
      "native": "Zambia",
      "phone": "260",
      "continent": "AF",
      "capital": "Lusaka",
      "currency": "ZMW",
      "languages": ["en"]
    },
    "ZW": {
      "name": "Zimbabwe",
      "native": "Zimbabwe",
      "phone": "263",
      "continent": "AF",
      "capital": "Harare",
      "currency": "USD,ZAR,BWP,GBP,AUD,CNY,INR,JPY",
      "languages": ["en", "sn", "nd"]
    }
  };

  static Map<String, List<dynamic>> getCountryNameFromMap() {
    Map<String, List<dynamic>> map = Map();
    countriesData.forEach((key, value) {
      String name = value['name'];
      String phone = value['phone'];
      List<String> currency = value['currency'].split(',');
      map.putIfAbsent(name, () => [phone, currency]);
    });
    return map;
  }

  static Map<String, List<dynamic>> countryInfo = getCountryNameFromMap();
}
