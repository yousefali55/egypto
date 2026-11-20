// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  static String m0(hours) => "متبقي ${hours} ساعة للرد";

  static String m1(count) =>
      "${Intl.plural(count, zero: 'لا توجد ليالٍ', one: 'ليلة واحدة', two: 'ليلتان', few: '${count} ليالٍ', many: '${count} ليلة', other: '${count} ليلة')}";

  static String m2(count) =>
      "${Intl.plural(count, one: 'ضيف واحد', two: 'ضيفان', few: '${count} ضيوف', many: '${count} ضيفًا', other: '${count} ضيف')}";

  static String m3(status, paymentStatus) =>
      "حالة الحجز: ${status}. حالة الدفع: ${paymentStatus}.";

  static String m4(count) =>
      "${Intl.plural(count, zero: 'لا يستقبل ضيوفًا', one: 'يتسع لضيف واحد', two: 'يتسع لضيفين', few: 'يتسع لـ ${count} ضيوف', many: 'يتسع لـ ${count} ضيفًا', other: 'يتسع لـ ${count} ضيف')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "MyAccount": MessageLookupByLibrary.simpleMessage("حسابي"),
    "acceptBooking": MessageLookupByLibrary.simpleMessage("قبول"),
    "acceptBookingConfirmation": MessageLookupByLibrary.simpleMessage(
      "سيتم تأكيد الحجز وسيظل مبلغ الدفع معلقًا.",
    ),
    "acceptBookingTitle": MessageLookupByLibrary.simpleMessage(
      "هل تريد قبول طلب الحجز؟",
    ),
    "accountType": MessageLookupByLibrary.simpleMessage("نوع الحساب"),
    "accountWaiting": MessageLookupByLibrary.simpleMessage(
      "مرحبًا بك في إيجيبتو",
    ),
    "accountWelcomeText": MessageLookupByLibrary.simpleMessage(
      "سجّل الدخول لإدارة حجوزاتك ومضيفيك وملفك الشخصي.",
    ),
    "addPhoneNumber": MessageLookupByLibrary.simpleMessage("أضف رقم هاتف"),
    "addPropertyTitle": MessageLookupByLibrary.simpleMessage("إضافة عقار"),
    "addPropertyUnauthorized": MessageLookupByLibrary.simpleMessage(
      "إضافة العقارات متاحة لحسابات المُضيف فقط.",
    ),
    "addToFavorites": MessageLookupByLibrary.simpleMessage("أضف إلى المفضلة"),
    "addressLabel": MessageLookupByLibrary.simpleMessage("العنوان"),
    "adminActionError": MessageLookupByLibrary.simpleMessage(
      "تعذر إكمال الطلب. سيظل ظاهرًا ضمن قائمة الانتظار.",
    ),
    "adminApprove": MessageLookupByLibrary.simpleMessage("موافقة"),
    "adminApproveConfirmation": MessageLookupByLibrary.simpleMessage(
      "هل تريد الموافقة على هذا الطلب؟",
    ),
    "adminApproveSuccess": MessageLookupByLibrary.simpleMessage(
      "تمت الموافقة على الطلب.",
    ),
    "adminDetailsError": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل التفاصيل. تحقق من اتصالك وحاول مرة أخرى.",
    ),
    "adminDocumentMissing": MessageLookupByLibrary.simpleMessage(
      "لم يتم تقديم هذا المستند.",
    ),
    "adminIdentityTab": MessageLookupByLibrary.simpleMessage("الهوية"),
    "adminIdentityTitle": MessageLookupByLibrary.simpleMessage(
      "طلبات التحقق المعلقة",
    ),
    "adminImageLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل الصورة. تحقق من اتصالك وحاول مرة أخرى.",
    ),
    "adminLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل طلبات المراجعة. تحقق من اتصالك وحاول مرة أخرى.",
    ),
    "adminNoIdentityRequests": MessageLookupByLibrary.simpleMessage(
      "لا توجد طلبات تحقق معلقة.",
    ),
    "adminNoPendingPayments": MessageLookupByLibrary.simpleMessage(
      "لا توجد إيصالات دفع بانتظار المراجعة.",
    ),
    "adminNoPendingProperties": MessageLookupByLibrary.simpleMessage(
      "لا توجد عقارات معلقة.",
    ),
    "adminPaymentReviewTitle": MessageLookupByLibrary.simpleMessage(
      "مراجعة الدفع",
    ),
    "adminPendingPaymentsTab": MessageLookupByLibrary.simpleMessage(
      "المدفوعات",
    ),
    "adminPendingPropertiesTab": MessageLookupByLibrary.simpleMessage(
      "العقارات المعلقة",
    ),
    "adminProfileTab": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
    "adminPropertiesTitle": MessageLookupByLibrary.simpleMessage(
      "العقارات المعلقة",
    ),
    "adminReference": MessageLookupByLibrary.simpleMessage("المعرّف"),
    "adminReject": MessageLookupByLibrary.simpleMessage("رفض"),
    "adminRejectConfirmation": MessageLookupByLibrary.simpleMessage(
      "هل تريد رفض هذا الطلب؟",
    ),
    "adminRejectSuccess": MessageLookupByLibrary.simpleMessage("تم رفض الطلب."),
    "adminReviewDetails": MessageLookupByLibrary.simpleMessage(
      "مراجعة التفاصيل",
    ),
    "adminRole": MessageLookupByLibrary.simpleMessage("مسؤول"),
    "adminSubmittedAt": MessageLookupByLibrary.simpleMessage("تاريخ الإرسال"),
    "adminUnauthorized": MessageLookupByLibrary.simpleMessage(
      "حسابك غير مخول لاستخدام أدوات المسؤول.",
    ),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "هل لديك حساب بالفعل؟",
    ),
    "amenitiesLabel": MessageLookupByLibrary.simpleMessage("المرافق"),
    "amenitiesLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل المرافق.",
    ),
    "anyGuests": MessageLookupByLibrary.simpleMessage("أي عدد"),
    "applyFilters": MessageLookupByLibrary.simpleMessage("تطبيق الفلاتر"),
    "back": MessageLookupByLibrary.simpleMessage("رجوع"),
    "bathroomsLabel": MessageLookupByLibrary.simpleMessage("الحمامات"),
    "becomeHost": MessageLookupByLibrary.simpleMessage("كن مُضيفًا"),
    "becomeHostConfirmation": MessageLookupByLibrary.simpleMessage(
      "سيتم تفعيل حسابك لاستضافة العقارات.",
    ),
    "becomeHostTitle": MessageLookupByLibrary.simpleMessage(
      "هل تريد أن تصبح مُضيفًا؟",
    ),
    "bedsLabel": MessageLookupByLibrary.simpleMessage("الأسرّة"),
    "bookingCheckInPast": MessageLookupByLibrary.simpleMessage(
      "لا يمكن أن يكون تسجيل الوصول قبل اليوم.",
    ),
    "bookingConfirmationTitle": MessageLookupByLibrary.simpleMessage(
      "طلب الحجز",
    ),
    "bookingConfirmed": MessageLookupByLibrary.simpleMessage("مؤكد"),
    "bookingCreatedAt": MessageLookupByLibrary.simpleMessage("تاريخ الطلب"),
    "bookingCreatedMessage": MessageLookupByLibrary.simpleMessage(
      "تم إرسال طلب الحجز.",
    ),
    "bookingDatesLabel": MessageLookupByLibrary.simpleMessage(
      "اختر مدة الإقامة",
    ),
    "bookingDatesUnavailable": MessageLookupByLibrary.simpleMessage(
      "لم تعد هذه التواريخ متاحة. اختر مدة أخرى.",
    ),
    "bookingDecidedAt": MessageLookupByLibrary.simpleMessage("تاريخ القرار"),
    "bookingDetailsTitle": MessageLookupByLibrary.simpleMessage("تفاصيل الحجز"),
    "bookingExpiresAt": MessageLookupByLibrary.simpleMessage(
      "انتهاء صلاحية الطلب",
    ),
    "bookingGenericError": MessageLookupByLibrary.simpleMessage(
      "تعذر إكمال طلب الحجز. حاول مرة أخرى.",
    ),
    "bookingHoursRemaining": m0,
    "bookingNetworkError": MessageLookupByLibrary.simpleMessage(
      "تعذر الاتصال. تحقق من اتصالك وحاول مرة أخرى.",
    ),
    "bookingNights": m1,
    "bookingNightsLabel": MessageLookupByLibrary.simpleMessage("عدد الليالي"),
    "bookingNotFound": MessageLookupByLibrary.simpleMessage(
      "تعذر العثور على هذا الحجز.",
    ),
    "bookingPaymentFailed": MessageLookupByLibrary.simpleMessage(
      "تعذر إتمام حجز مبلغ الدفع. حاول مرة أخرى.",
    ),
    "bookingPending": MessageLookupByLibrary.simpleMessage("قيد الانتظار"),
    "bookingReferenceLabel": MessageLookupByLibrary.simpleMessage("مرجع الحجز"),
    "bookingRejected": MessageLookupByLibrary.simpleMessage("مرفوض"),
    "bookingStateNoLongerValid": MessageLookupByLibrary.simpleMessage(
      "لم يعد طلب الحجز متاحًا لاتخاذ قرار بشأنه.",
    ),
    "bookingStatusLabel": MessageLookupByLibrary.simpleMessage("حالة الحجز"),
    "bookingStayLengthInvalid": MessageLookupByLibrary.simpleMessage(
      "اختر إقامة من ليلة واحدة إلى 30 ليلة.",
    ),
    "bookingUnauthorized": MessageLookupByLibrary.simpleMessage(
      "لا تملك صلاحية عرض هذا الحجز.",
    ),
    "bookingValidationFailed": MessageLookupByLibrary.simpleMessage(
      "تعذر قبول بيانات الحجز. راجع التواريخ وحاول مجددًا.",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "checkInDate": MessageLookupByLibrary.simpleMessage("تسجيل الوصول"),
    "checkOtp": MessageLookupByLibrary.simpleMessage(
      "تحقق من الرسالة المرسلة إلى بريدك الإلكتروني",
    ),
    "checkOutDate": MessageLookupByLibrary.simpleMessage("تسجيل المغادرة"),
    "choosePropertyImages": MessageLookupByLibrary.simpleMessage(
      "اختيار الصور",
    ),
    "chooseYourRole": MessageLookupByLibrary.simpleMessage("اختر دورك"),
    "cityFieldHint": MessageLookupByLibrary.simpleMessage(
      "اختر مدينة أو أدخل اسمها",
    ),
    "cityLabel": MessageLookupByLibrary.simpleMessage("المدينة"),
    "clearFilters": MessageLookupByLibrary.simpleMessage("مسح الفلاتر والبحث"),
    "comingSoon": MessageLookupByLibrary.simpleMessage("قريبًا"),
    "completeIdentityVerification": MessageLookupByLibrary.simpleMessage(
      "أكمل التحقق من الهوية",
    ),
    "confirmBooking": MessageLookupByLibrary.simpleMessage("تأكيد الطلب"),
    "confirmBookingTitle": MessageLookupByLibrary.simpleMessage(
      "راجع طلب الحجز",
    ),
    "confirmPassword": MessageLookupByLibrary.simpleMessage(
      "تأكيد كلمة المرور",
    ),
    "continueLabel": MessageLookupByLibrary.simpleMessage("متابعة"),
    "countryLabel": MessageLookupByLibrary.simpleMessage("الدولة"),
    "createAccount": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
    "datesLabel": MessageLookupByLibrary.simpleMessage("تواريخ الإقامة"),
    "decreaseGuests": MessageLookupByLibrary.simpleMessage("تقليل عدد الضيوف"),
    "done": MessageLookupByLibrary.simpleMessage("تم"),
    "dontHaveAccount": MessageLookupByLibrary.simpleMessage("ليس لديك حساب؟"),
    "editPhoneDescription": MessageLookupByLibrary.simpleMessage(
      "أضف رقم هاتفك لحفظ بيانات حسابك وتحديثها.",
    ),
    "editPhoneNumber": MessageLookupByLibrary.simpleMessage("تعديل رقم الهاتف"),
    "editPhoneTitle": MessageLookupByLibrary.simpleMessage("رقم هاتفك"),
    "egp": MessageLookupByLibrary.simpleMessage("جنيه مصري"),
    "egyptMobileHint": MessageLookupByLibrary.simpleMessage(
      "أدخل رقم هاتف محمول مصريًا، مع أو بدون ‎+20.",
    ),
    "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
    "enterData": MessageLookupByLibrary.simpleMessage("أدخل بياناتك للمتابعة"),
    "enterVerficationCode": MessageLookupByLibrary.simpleMessage(
      "أدخل رمز التأكيد",
    ),
    "explore": MessageLookupByLibrary.simpleMessage("إكتشف"),
    "fieldRequired": MessageLookupByLibrary.simpleMessage("هذا الحقل مطلوب."),
    "filters": MessageLookupByLibrary.simpleMessage("الفلاتر"),
    "financialSnapshotTitle": MessageLookupByLibrary.simpleMessage(
      "الملخص المالي للحجز",
    ),
    "firstName": MessageLookupByLibrary.simpleMessage("الاسم الأول"),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("نسيت كلمة المرور؟"),
    "fullName": MessageLookupByLibrary.simpleMessage("الاسم الكامل"),
    "getStarted": MessageLookupByLibrary.simpleMessage("ابدأ الآن"),
    "governorateLabel": MessageLookupByLibrary.simpleMessage("المحافظة"),
    "grossAmountLabel": MessageLookupByLibrary.simpleMessage("الإجمالي"),
    "guest": MessageLookupByLibrary.simpleMessage("ضيف"),
    "guestBookingOnly": MessageLookupByLibrary.simpleMessage(
      "طلبات الحجز متاحة للضيوف فقط",
    ),
    "guestBookingsTitle": MessageLookupByLibrary.simpleMessage("حجوزاتي"),
    "guestBookingsUnauthorized": MessageLookupByLibrary.simpleMessage(
      "الحجوزات غير متاحة لهذا الحساب.",
    ),
    "guestCount": m2,
    "guestNameLabel": MessageLookupByLibrary.simpleMessage("الضيف"),
    "guestsLabel": MessageLookupByLibrary.simpleMessage("الضيوف"),
    "home": MessageLookupByLibrary.simpleMessage("الرئيسية"),
    "homeLocation": MessageLookupByLibrary.simpleMessage("القاهرة، مصر"),
    "host": MessageLookupByLibrary.simpleMessage("مُضيف"),
    "hostActivationFailure": MessageLookupByLibrary.simpleMessage(
      "تعذر تفعيل حساب المُضيف. حاول مرة أخرى.",
    ),
    "hostActivationSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تفعيل حسابك كمُضيف.",
    ),
    "hostAmountLabel": MessageLookupByLibrary.simpleMessage("مستحق المضيف"),
    "hostBookingsTitle": MessageLookupByLibrary.simpleMessage("طلبات الحجز"),
    "hostBookingsUnauthorized": MessageLookupByLibrary.simpleMessage(
      "طلبات الحجز متاحة للمضيفين فقط.",
    ),
    "hostDecisionSuccess": m3,
    "hostPropertiesTitle": MessageLookupByLibrary.simpleMessage("عقاراتي"),
    "identityAuthError": MessageLookupByLibrary.simpleMessage(
      "ربما انتهت صلاحية جلستك. سجّل الدخول مجددًا قبل الإرسال.",
    ),
    "identityCamera": MessageLookupByLibrary.simpleMessage("التقاط صورة"),
    "identityChooseImage": MessageLookupByLibrary.simpleMessage("اختيار صورة"),
    "identityConfirmSubmit": MessageLookupByLibrary.simpleMessage(
      "تأكيد وإرسال",
    ),
    "identityConfirmation": MessageLookupByLibrary.simpleMessage(
      "أؤكد أن هذه الصور تخصني وأنها جاهزة للإرسال لمراجعة الهوية.",
    ),
    "identityDocument": MessageLookupByLibrary.simpleMessage(
      "صورة بطاقة الرقم القومي",
    ),
    "identityExistingRequest": MessageLookupByLibrary.simpleMessage(
      "يوجد طلب تحقق سابق لحسابك. تظهر حالته الحالية أعلاه.",
    ),
    "identityFlowTitle": MessageLookupByLibrary.simpleMessage(
      "التحقق من الهوية",
    ),
    "identityGallery": MessageLookupByLibrary.simpleMessage(
      "الاختيار من المعرض",
    ),
    "identityGenericError": MessageLookupByLibrary.simpleMessage(
      "تعذّر إرسال مستندات الهوية. يُرجى المحاولة مرة أخرى.",
    ),
    "identityIdBack": MessageLookupByLibrary.simpleMessage(
      "الوجه الخلفي للبطاقة",
    ),
    "identityIdBackInstructions": MessageLookupByLibrary.simpleMessage(
      "صوّر الوجه الخلفي لبطاقة الرقم القومي. أظهر البطاقة كاملة واجعل النص واضحًا.",
    ),
    "identityIdFront": MessageLookupByLibrary.simpleMessage(
      "الوجه الأمامي للبطاقة",
    ),
    "identityIdFrontInstructions": MessageLookupByLibrary.simpleMessage(
      "صوّر الوجه الأمامي لبطاقة الرقم القومي. أظهر البطاقة كاملة واجعل النص واضحًا.",
    ),
    "identityImageReady": MessageLookupByLibrary.simpleMessage(
      "تمت إضافة الصورة",
    ),
    "identityImageUnavailable": MessageLookupByLibrary.simpleMessage(
      "تعذّر فتح هذه الصورة. يُرجى اختيارها مرة أخرى.",
    ),
    "identityNetworkError": MessageLookupByLibrary.simpleMessage(
      "تعذّر الاتصال. صورك المحددة ما زالت محفوظة في هذه الشاشة؛ حاول مرة أخرى.",
    ),
    "identityNotSubmitted": MessageLookupByLibrary.simpleMessage(
      "لم يتم تقديم طلب التحقق",
    ),
    "identityNotVerifiedForBooking": MessageLookupByLibrary.simpleMessage(
      "يجب التحقق من الهوية قبل الحجز.",
    ),
    "identityPending": MessageLookupByLibrary.simpleMessage("قيد المراجعة"),
    "identityPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "تم رفض الوصول إلى الكاميرا أو الصور. اسمح بالوصول من إعدادات الجهاز ثم حاول مجددًا.",
    ),
    "identityPrivacyNote": MessageLookupByLibrary.simpleMessage(
      "سيتم رفع صورك بأمان بعد مراجعتها وتأكيد الإرسال فقط.",
    ),
    "identityRejected": MessageLookupByLibrary.simpleMessage(
      "تم رفض التحقق من الهوية",
    ),
    "identityRejectedRetryPrompt": MessageLookupByLibrary.simpleMessage(
      "تم رفض التحقق من هويتك. يمكنك المحاولة مرة أخرى عن طريق رفع صور الهوية من جديد.",
    ),
    "identityReplaceImage": MessageLookupByLibrary.simpleMessage(
      "إعادة التصوير أو الاستبدال",
    ),
    "identityReview": MessageLookupByLibrary.simpleMessage("مراجعة"),
    "identityReviewDescription": MessageLookupByLibrary.simpleMessage(
      "تأكد من وضوح الصور الثلاث وإمكانية قراءة البيانات قبل الإرسال.",
    ),
    "identityReviewTitle": MessageLookupByLibrary.simpleMessage("راجع صورك"),
    "identitySelfie": MessageLookupByLibrary.simpleMessage("صورة شخصية"),
    "identitySelfieInstructions": MessageLookupByLibrary.simpleMessage(
      "التقط صورة واضحة لوجهك في إضاءة جيدة، وتأكد من ظهور وجهك بالكامل.",
    ),
    "identityServerError": MessageLookupByLibrary.simpleMessage(
      "الخدمة غير متاحة مؤقتًا. صورك ما زالت محفوظة هنا؛ حاول لاحقًا.",
    ),
    "identitySubmissionPending": MessageLookupByLibrary.simpleMessage(
      "تم إرسال مستنداتك بنجاح. لا يعني الإرسال الموافقة على هويتك.",
    ),
    "identitySubmissionReceived": MessageLookupByLibrary.simpleMessage(
      "تم استلام الطلب",
    ),
    "identityTryAgain": MessageLookupByLibrary.simpleMessage(
      "المحاولة مرة أخرى",
    ),
    "identityUnknown": MessageLookupByLibrary.simpleMessage("غير معروف"),
    "identityUploading": MessageLookupByLibrary.simpleMessage("جارٍ الرفع…"),
    "identityValidationError": MessageLookupByLibrary.simpleMessage(
      "تعذّر على الخادم قبول الصور. تحقق منها ثم حاول مرة أخرى.",
    ),
    "identityVerification": MessageLookupByLibrary.simpleMessage(
      "التحقق من الهوية",
    ),
    "identityVerified": MessageLookupByLibrary.simpleMessage(
      "تم التحقق من الهوية",
    ),
    "imageSelectionCount": MessageLookupByLibrary.simpleMessage("صور محددة"),
    "increaseGuests": MessageLookupByLibrary.simpleMessage("زيادة عدد الضيوف"),
    "instapayConfigurationMissing": MessageLookupByLibrary.simpleMessage(
      "بيانات حساب إنستاباي الرسمي غير مُعدة في التطبيق حاليًا. لا ترسل أي مبلغ حتى تتوفر هذه البيانات.",
    ),
    "instapayInstructions": MessageLookupByLibrary.simpleMessage(
      "حوّل مبلغ الحجز كاملًا عبر إنستاباي، ثم ارفع لقطة شاشة واضحة لإيصال التحويل.",
    ),
    "invalidCount": MessageLookupByLibrary.simpleMessage("أدخل عددًا صحيحًا."),
    "invalidDateRange": MessageLookupByLibrary.simpleMessage(
      "يجب أن يكون تسجيل المغادرة بعد تسجيل الوصول.",
    ),
    "invalidEgyptianMobile": MessageLookupByLibrary.simpleMessage(
      "أدخل رقم هاتف محمول مصريًا صحيحًا.",
    ),
    "invalidLatitude": MessageLookupByLibrary.simpleMessage(
      "يجب أن يكون خط العرض بين ‎-90 و90.",
    ),
    "invalidLongitude": MessageLookupByLibrary.simpleMessage(
      "يجب أن يكون خط الطول بين ‎-180 و180.",
    ),
    "invalidPositiveNumber": MessageLookupByLibrary.simpleMessage(
      "أدخل رقمًا صحيحًا أكبر من صفر.",
    ),
    "lastName": MessageLookupByLibrary.simpleMessage("الاسم الأخير"),
    "latitudeLabel": MessageLookupByLibrary.simpleMessage("خط العرض"),
    "loadMore": MessageLookupByLibrary.simpleMessage("تحميل المزيد"),
    "loadingAccount": MessageLookupByLibrary.simpleMessage(
      "جارٍ تحميل حسابك...",
    ),
    "location": MessageLookupByLibrary.simpleMessage("الموقع"),
    "login": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "loginSuccessfull": MessageLookupByLibrary.simpleMessage(
      "تم تسجيل دخولك بنجاح",
    ),
    "loginToBook": MessageLookupByLibrary.simpleMessage(
      "سجّل الدخول لطلب الحجز",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "logoutConfirmation": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد أنك تريد تسجيل الخروج؟",
    ),
    "logoutFailed": MessageLookupByLibrary.simpleMessage(
      "تعذّر تسجيل الخروج. يُرجى المحاولة مرة أخرى.",
    ),
    "longitudeLabel": MessageLookupByLibrary.simpleMessage("خط الطول"),
    "map": MessageLookupByLibrary.simpleMessage("الخريطة"),
    "messages": MessageLookupByLibrary.simpleMessage("الرسائل"),
    "minimumImagesRequired": MessageLookupByLibrary.simpleMessage(
      "الحد الأدنى ٤ صور",
    ),
    "monthly": MessageLookupByLibrary.simpleMessage("شهريًا"),
    "myHome": MessageLookupByLibrary.simpleMessage("منزلي"),
    "next": MessageLookupByLibrary.simpleMessage("التالي"),
    "night": MessageLookupByLibrary.simpleMessage("لليلة"),
    "nightlyPriceLabel": MessageLookupByLibrary.simpleMessage("السعر لليلة"),
    "noGuestBookings": MessageLookupByLibrary.simpleMessage(
      "ليس لديك حجوزات حتى الآن.",
    ),
    "noHostBookings": MessageLookupByLibrary.simpleMessage(
      "لا توجد طلبات حجز معلقة.",
    ),
    "noHostProperties": MessageLookupByLibrary.simpleMessage(
      "لم تضف أي عقارات بعد.",
    ),
    "noPropertiesFound": MessageLookupByLibrary.simpleMessage(
      "لا توجد عقارات مطابقة لبحثك",
    ),
    "notAvailable": MessageLookupByLibrary.simpleMessage("غير متاح"),
    "notifications": MessageLookupByLibrary.simpleMessage("الإشعارات"),
    "onBoardingDescription": MessageLookupByLibrary.simpleMessage(
      "اكتشف أفضل السكنات المتاحة في منطقتك بكل سهولة وسرعة",
    ),
    "onBoardingDescription2": MessageLookupByLibrary.simpleMessage(
      "تواصل مع المالك مباشرة واحجز السكن المناسب لك بأمان",
    ),
    "onBoardingDescription3": MessageLookupByLibrary.simpleMessage(
      "استمتع بإقامتك في السكن الذي اخترته واستمتع بتجربة لا تُنسى",
    ),
    "onBoardingTitle": MessageLookupByLibrary.simpleMessage("ابحث بسهولة"),
    "onBoardingTitle2": MessageLookupByLibrary.simpleMessage("احجز بكل ثقة"),
    "onBoardingTitle3": MessageLookupByLibrary.simpleMessage("استمتع بإقامتك"),
    "otpCodeRequired": MessageLookupByLibrary.simpleMessage(
      "أدخل الرمز المكوّن من ستة أرقام كاملًا.",
    ),
    "otpGenericError": MessageLookupByLibrary.simpleMessage(
      "تعذر إكمال الطلب. حاول مجددًا.",
    ),
    "otpInvalidOrExpired": MessageLookupByLibrary.simpleMessage(
      "الرمز غير صحيح أو انتهت صلاحيته. تحقق منه وحاول مجددًا.",
    ),
    "otpNetworkError": MessageLookupByLibrary.simpleMessage(
      "تعذر الاتصال. تحقق من اتصالك وحاول مجددًا.",
    ),
    "otpResendAvailableIn": MessageLookupByLibrary.simpleMessage(
      "يمكنك إعادة إرسال الرمز خلال",
    ),
    "otpResendSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إرسال رمز تحقق جديد.",
    ),
    "otpResending": MessageLookupByLibrary.simpleMessage(
      "جارٍ إرسال رمز جديد...",
    ),
    "otpServerError": MessageLookupByLibrary.simpleMessage(
      "الخدمة غير متاحة مؤقتًا. حاول مجددًا لاحقًا.",
    ),
    "otpVerificationSuccess": MessageLookupByLibrary.simpleMessage(
      "تم التحقق من البريد الإلكتروني. سجّل الدخول للمتابعة.",
    ),
    "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "paymentHeld": MessageLookupByLibrary.simpleMessage("معلّق"),
    "paymentInstructionsTitle": MessageLookupByLibrary.simpleMessage(
      "الدفع عبر إنستاباي",
    ),
    "paymentReceiptChoose": MessageLookupByLibrary.simpleMessage(
      "اختيار صورة الإيصال",
    ),
    "paymentReceiptFormatError": MessageLookupByLibrary.simpleMessage(
      "صور الإيصال المدعومة هي JPG وPNG فقط.",
    ),
    "paymentReceiptImageError": MessageLookupByLibrary.simpleMessage(
      "تعذر فتح الصورة المحددة.",
    ),
    "paymentReceiptLabel": MessageLookupByLibrary.simpleMessage("إيصال الدفع"),
    "paymentReceiptMissing": MessageLookupByLibrary.simpleMessage(
      "لم يتم إرجاع صورة إيصال لهذا الدفع.",
    ),
    "paymentReceiptReplace": MessageLookupByLibrary.simpleMessage(
      "استبدال صورة الإيصال",
    ),
    "paymentReceiptSelectFirst": MessageLookupByLibrary.simpleMessage(
      "اختر صورة الإيصال أولًا.",
    ),
    "paymentReceiptSelectImage": MessageLookupByLibrary.simpleMessage(
      "اختر لقطة شاشة من إنستاباي",
    ),
    "paymentReceiptSizeError": MessageLookupByLibrary.simpleMessage(
      "يجب ألا يتجاوز حجم صورة الإيصال 10 ميجابايت.",
    ),
    "paymentReceiptSubmit": MessageLookupByLibrary.simpleMessage(
      "إرسال الإيصال",
    ),
    "paymentReceiptSubmitted": MessageLookupByLibrary.simpleMessage(
      "تم إرسال الإيصال بنجاح. بانتظار مراجعة المسؤول.",
    ),
    "paymentReceiptUploadError": MessageLookupByLibrary.simpleMessage(
      "تعذر إرسال الإيصال. حاول مرة أخرى.",
    ),
    "paymentReceiptUploading": MessageLookupByLibrary.simpleMessage(
      "جارٍ رفع الإيصال...",
    ),
    "paymentRefunded": MessageLookupByLibrary.simpleMessage("مسترد"),
    "paymentStatusLabel": MessageLookupByLibrary.simpleMessage("حالة الدفع"),
    "paymentUploadButton": MessageLookupByLibrary.simpleMessage(
      "الدفع عبر إنستاباي",
    ),
    "personalInfo": MessageLookupByLibrary.simpleMessage("المعلومات الشخصية"),
    "phone": MessageLookupByLibrary.simpleMessage("رقم الهاتف"),
    "phoneProfileUnavailable": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل بيانات ملفك الشخصي. يُرجى المحاولة مرة أخرى قبل تحديث رقمك.",
    ),
    "phoneRequired": MessageLookupByLibrary.simpleMessage("أدخل رقم هاتفك."),
    "phoneUpdateAuthError": MessageLookupByLibrary.simpleMessage(
      "ربما انتهت صلاحية جلستك. سجّل الدخول ثم أعد المحاولة.",
    ),
    "phoneUpdateGenericError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحديث رقم الهاتف. يُرجى المحاولة مرة أخرى.",
    ),
    "phoneUpdateNetworkError": MessageLookupByLibrary.simpleMessage(
      "تعذّر الاتصال. تحقّق من اتصالك وحاول مرة أخرى.",
    ),
    "phoneUpdateServerError": MessageLookupByLibrary.simpleMessage(
      "الخدمة غير متاحة مؤقتًا. حاول مرة أخرى لاحقًا.",
    ),
    "phoneUpdateSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تحديث رقم الهاتف بنجاح.",
    ),
    "phoneUpdateValidationError": MessageLookupByLibrary.simpleMessage(
      "لم يتم قبول رقم الهاتف. تحقّق منه وحاول مرة أخرى.",
    ),
    "profileRefreshError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحديث ملفك الشخصي. تحقق من اتصالك وحاول مرة أخرى.",
    ),
    "propertiesLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل العقارات. تحقق من اتصالك وحاول مرة أخرى.",
    ),
    "propertyCapacity": m4,
    "propertyCreating": MessageLookupByLibrary.simpleMessage(
      "جارٍ إنشاء العقار…",
    ),
    "propertyCreationIdMissing": MessageLookupByLibrary.simpleMessage(
      "لم يُرجع الخادم معرّف العقار. لن تتم إعادة الإنشاء تلقائيًا.",
    ),
    "propertyDescriptionLabel": MessageLookupByLibrary.simpleMessage("الوصف"),
    "propertyDetailsTitle": MessageLookupByLibrary.simpleMessage(
      "تفاصيل العقار",
    ),
    "propertyFamilyApartment": MessageLookupByLibrary.simpleMessage(
      "شقة عائلية للأسرة",
    ),
    "propertyFurnishedApartment": MessageLookupByLibrary.simpleMessage(
      "شقة مفروشة بالقرب من الخدمات",
    ),
    "propertyImagesLabel": MessageLookupByLibrary.simpleMessage("صور العقار"),
    "propertyLocationGiza": MessageLookupByLibrary.simpleMessage("الجيزة، مصر"),
    "propertyLocationNasrCity": MessageLookupByLibrary.simpleMessage(
      "مدينة نصر، مصر",
    ),
    "propertyLocationNewCairo": MessageLookupByLibrary.simpleMessage(
      "القاهرة الجديدة، مصر",
    ),
    "propertyModernApartment": MessageLookupByLibrary.simpleMessage(
      "شقة عصرية بإطلالة مميزة",
    ),
    "propertyStatusMissing": MessageLookupByLibrary.simpleMessage(
      "لم يُرجع الخادم الحالة النهائية للعقار.",
    ),
    "propertySubmissionSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إرسال العقار بالحالة:",
    ),
    "propertySubmitting": MessageLookupByLibrary.simpleMessage(
      "جارٍ الإرسال للمراجعة…",
    ),
    "propertyTitleLabel": MessageLookupByLibrary.simpleMessage("عنوان العقار"),
    "propertyUploading": MessageLookupByLibrary.simpleMessage(
      "جارٍ رفع الصور…",
    ),
    "propertyWorkflowError": MessageLookupByLibrary.simpleMessage(
      "تعذرت العملية. راجع التفاصيل ثم حاول مرة أخرى.",
    ),
    "refreshProfile": MessageLookupByLibrary.simpleMessage(
      "تحديث الملف الشخصي",
    ),
    "register": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
    "registerNewAcc": MessageLookupByLibrary.simpleMessage("تسجيل حساب جديد"),
    "rejectBooking": MessageLookupByLibrary.simpleMessage("رفض"),
    "rejectBookingConfirmation": MessageLookupByLibrary.simpleMessage(
      "سيتم رفض الحجز وسيتولى الخادم معالجة أي استرداد.",
    ),
    "rejectBookingTitle": MessageLookupByLibrary.simpleMessage(
      "هل تريد رفض طلب الحجز؟",
    ),
    "removeFromFavorites": MessageLookupByLibrary.simpleMessage(
      "إزالة من المفضلة",
    ),
    "removePropertyImage": MessageLookupByLibrary.simpleMessage("إزالة الصورة"),
    "requestBooking": MessageLookupByLibrary.simpleMessage("طلب حجز"),
    "resendCode": MessageLookupByLibrary.simpleMessage("إعادة إرسال الرمز"),
    "resetFilters": MessageLookupByLibrary.simpleMessage("إعادة ضبط الفلاتر"),
    "resetPassword": MessageLookupByLibrary.simpleMessage(
      "إعادة تعيين كلمة المرور",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "roleRequired": MessageLookupByLibrary.simpleMessage(
      "اختر نوع الحساب للمتابعة.",
    ),
    "roomsLabel": MessageLookupByLibrary.simpleMessage("الغرف"),
    "savePhoneNumber": MessageLookupByLibrary.simpleMessage("حفظ رقم الهاتف"),
    "search": MessageLookupByLibrary.simpleMessage("بحث..."),
    "selectBookingDates": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخي تسجيل الوصول والمغادرة.",
    ),
    "selectBothDates": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخي تسجيل الوصول والمغادرة.",
    ),
    "selectDate": MessageLookupByLibrary.simpleMessage("اختر التاريخ"),
    "serviceFeeLabel": MessageLookupByLibrary.simpleMessage("رسوم الخدمة"),
    "skip": MessageLookupByLibrary.simpleMessage("تخطي"),
    "submitProperty": MessageLookupByLibrary.simpleMessage(
      "إنشاء وإرسال للمراجعة",
    ),
    "unknownStatus": MessageLookupByLibrary.simpleMessage("حالة غير معروفة"),
    "verify": MessageLookupByLibrary.simpleMessage("تحقق"),
  };
}
