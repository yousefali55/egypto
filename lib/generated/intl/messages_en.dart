// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(hours) => "${hours} hours remaining to respond";

  static String m1(count) =>
      "${Intl.plural(count, one: '1 night', other: '${count} nights')}";

  static String m2(count) =>
      "${Intl.plural(count, one: '1 guest', other: '${count} guests')}";

  static String m3(status, paymentStatus) =>
      "Booking status: ${status}. Payment status: ${paymentStatus}.";

  static String m4(count) =>
      "${Intl.plural(count, one: 'Up to 1 guest', other: 'Up to ${count} guests')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "MyAccount": MessageLookupByLibrary.simpleMessage("Account"),
    "acceptBooking": MessageLookupByLibrary.simpleMessage("Accept"),
    "acceptBookingConfirmation": MessageLookupByLibrary.simpleMessage(
      "The booking will be confirmed and the payment remains held.",
    ),
    "acceptBookingTitle": MessageLookupByLibrary.simpleMessage(
      "Accept booking request?",
    ),
    "accountType": MessageLookupByLibrary.simpleMessage("Account type"),
    "accountWaiting": MessageLookupByLibrary.simpleMessage("Welcome to Egypto"),
    "accountWelcomeText": MessageLookupByLibrary.simpleMessage(
      "Sign in to manage your reservations, hosts, and personal profile.",
    ),
    "addPhoneNumber": MessageLookupByLibrary.simpleMessage("Add phone number"),
    "addPropertyTitle": MessageLookupByLibrary.simpleMessage("Add property"),
    "addPropertyUnauthorized": MessageLookupByLibrary.simpleMessage(
      "Only Host accounts can add properties.",
    ),
    "addToFavorites": MessageLookupByLibrary.simpleMessage("Add to favorites"),
    "addressLabel": MessageLookupByLibrary.simpleMessage("Address"),
    "adminActionError": MessageLookupByLibrary.simpleMessage(
      "The request could not be completed. It remains in the pending queue.",
    ),
    "adminApprove": MessageLookupByLibrary.simpleMessage("Approve"),
    "adminApproveConfirmation": MessageLookupByLibrary.simpleMessage(
      "Approve this request?",
    ),
    "adminApproveSuccess": MessageLookupByLibrary.simpleMessage(
      "Request approved.",
    ),
    "adminDetailsError": MessageLookupByLibrary.simpleMessage(
      "Could not load these details. Check your connection and try again.",
    ),
    "adminDocumentMissing": MessageLookupByLibrary.simpleMessage(
      "This document was not provided.",
    ),
    "adminIdentityTab": MessageLookupByLibrary.simpleMessage("Identity"),
    "adminIdentityTitle": MessageLookupByLibrary.simpleMessage(
      "Pending identity requests",
    ),
    "adminImageLoadError": MessageLookupByLibrary.simpleMessage(
      "Could not load this image. Check your connection and retry.",
    ),
    "adminLoadError": MessageLookupByLibrary.simpleMessage(
      "Could not load review requests. Check your connection and try again.",
    ),
    "adminNoIdentityRequests": MessageLookupByLibrary.simpleMessage(
      "There are no pending identity requests.",
    ),
    "adminNoPendingPayments": MessageLookupByLibrary.simpleMessage(
      "There are no pending payment receipts.",
    ),
    "adminNoPendingProperties": MessageLookupByLibrary.simpleMessage(
      "There are no pending properties.",
    ),
    "adminPaymentReviewTitle": MessageLookupByLibrary.simpleMessage(
      "Payment review",
    ),
    "adminPendingPaymentsTab": MessageLookupByLibrary.simpleMessage("Payments"),
    "adminPendingPropertiesTab": MessageLookupByLibrary.simpleMessage(
      "Pending Properties",
    ),
    "adminProfileTab": MessageLookupByLibrary.simpleMessage("Profile"),
    "adminPropertiesTitle": MessageLookupByLibrary.simpleMessage(
      "Pending properties",
    ),
    "adminReference": MessageLookupByLibrary.simpleMessage("Reference"),
    "adminReject": MessageLookupByLibrary.simpleMessage("Reject"),
    "adminRejectConfirmation": MessageLookupByLibrary.simpleMessage(
      "Reject this request?",
    ),
    "adminRejectSuccess": MessageLookupByLibrary.simpleMessage(
      "Request rejected.",
    ),
    "adminReviewDetails": MessageLookupByLibrary.simpleMessage(
      "Review details",
    ),
    "adminRole": MessageLookupByLibrary.simpleMessage("Administrator"),
    "adminSubmittedAt": MessageLookupByLibrary.simpleMessage("Submitted at"),
    "adminUnauthorized": MessageLookupByLibrary.simpleMessage(
      "Your account is not authorized to use Admin tools.",
    ),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "amenitiesLabel": MessageLookupByLibrary.simpleMessage("Amenities"),
    "amenitiesLoadError": MessageLookupByLibrary.simpleMessage(
      "Could not load amenities.",
    ),
    "anyGuests": MessageLookupByLibrary.simpleMessage("Any number"),
    "applyFilters": MessageLookupByLibrary.simpleMessage("Apply filters"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "bathroomsLabel": MessageLookupByLibrary.simpleMessage("Bathrooms"),
    "becomeHost": MessageLookupByLibrary.simpleMessage("Become a Host"),
    "becomeHostConfirmation": MessageLookupByLibrary.simpleMessage(
      "Your account will be activated for hosting.",
    ),
    "becomeHostTitle": MessageLookupByLibrary.simpleMessage("Become a Host?"),
    "bedsLabel": MessageLookupByLibrary.simpleMessage("Beds"),
    "bookingCheckInPast": MessageLookupByLibrary.simpleMessage(
      "Check-in cannot be before today.",
    ),
    "bookingConfirmationTitle": MessageLookupByLibrary.simpleMessage(
      "Booking request",
    ),
    "bookingConfirmed": MessageLookupByLibrary.simpleMessage("Confirmed"),
    "bookingCreatedAt": MessageLookupByLibrary.simpleMessage("Requested on"),
    "bookingCreatedMessage": MessageLookupByLibrary.simpleMessage(
      "Your booking request was submitted.",
    ),
    "bookingDatesLabel": MessageLookupByLibrary.simpleMessage(
      "Choose your stay",
    ),
    "bookingDatesUnavailable": MessageLookupByLibrary.simpleMessage(
      "These dates are no longer available. Choose another range.",
    ),
    "bookingDecidedAt": MessageLookupByLibrary.simpleMessage("Decision time"),
    "bookingDetailsTitle": MessageLookupByLibrary.simpleMessage(
      "Booking details",
    ),
    "bookingExpiresAt": MessageLookupByLibrary.simpleMessage("Request expires"),
    "bookingGenericError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t complete this booking request. Please try again.",
    ),
    "bookingHoursRemaining": m0,
    "bookingNetworkError": MessageLookupByLibrary.simpleMessage(
      "Could not connect. Check your connection and try again.",
    ),
    "bookingNights": m1,
    "bookingNightsLabel": MessageLookupByLibrary.simpleMessage("Nights"),
    "bookingNotFound": MessageLookupByLibrary.simpleMessage(
      "This booking could not be found.",
    ),
    "bookingPaymentFailed": MessageLookupByLibrary.simpleMessage(
      "The payment hold could not be completed. Please try again.",
    ),
    "bookingPending": MessageLookupByLibrary.simpleMessage("Pending"),
    "bookingReferenceLabel": MessageLookupByLibrary.simpleMessage(
      "Booking reference",
    ),
    "bookingRejected": MessageLookupByLibrary.simpleMessage("Rejected"),
    "bookingStateNoLongerValid": MessageLookupByLibrary.simpleMessage(
      "This booking request is no longer available to decide.",
    ),
    "bookingStatusLabel": MessageLookupByLibrary.simpleMessage(
      "Booking status",
    ),
    "bookingStayLengthInvalid": MessageLookupByLibrary.simpleMessage(
      "Choose a stay between 1 and 30 nights.",
    ),
    "bookingUnauthorized": MessageLookupByLibrary.simpleMessage(
      "You are not authorized to view this booking.",
    ),
    "bookingValidationFailed": MessageLookupByLibrary.simpleMessage(
      "The booking details were rejected. Review the dates and try again.",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "checkInDate": MessageLookupByLibrary.simpleMessage("Check-in"),
    "checkOtp": MessageLookupByLibrary.simpleMessage(
      "Check the message sent to your email",
    ),
    "checkOutDate": MessageLookupByLibrary.simpleMessage("Check-out"),
    "choosePropertyImages": MessageLookupByLibrary.simpleMessage(
      "Choose images",
    ),
    "chooseYourRole": MessageLookupByLibrary.simpleMessage("Choose your role"),
    "cityFieldHint": MessageLookupByLibrary.simpleMessage(
      "Choose or enter a city",
    ),
    "cityLabel": MessageLookupByLibrary.simpleMessage("City"),
    "clearFilters": MessageLookupByLibrary.simpleMessage(
      "Clear filters and search",
    ),
    "comingSoon": MessageLookupByLibrary.simpleMessage("Coming soon"),
    "completeIdentityVerification": MessageLookupByLibrary.simpleMessage(
      "Complete identity verification",
    ),
    "confirmBooking": MessageLookupByLibrary.simpleMessage("Confirm request"),
    "confirmBookingTitle": MessageLookupByLibrary.simpleMessage(
      "Review your booking request",
    ),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("Confirm Password"),
    "continueLabel": MessageLookupByLibrary.simpleMessage("Continue"),
    "countryLabel": MessageLookupByLibrary.simpleMessage("Country"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Create account"),
    "datesLabel": MessageLookupByLibrary.simpleMessage("Stay dates"),
    "decreaseGuests": MessageLookupByLibrary.simpleMessage("Decrease guests"),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "dontHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account?",
    ),
    "editPhoneDescription": MessageLookupByLibrary.simpleMessage(
      "Add a phone number to keep your account details up to date.",
    ),
    "editPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Edit phone number",
    ),
    "editPhoneTitle": MessageLookupByLibrary.simpleMessage("Your phone number"),
    "egp": MessageLookupByLibrary.simpleMessage("EGP"),
    "egyptMobileHint": MessageLookupByLibrary.simpleMessage(
      "Enter an Egyptian mobile number, with or without +20.",
    ),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "enterData": MessageLookupByLibrary.simpleMessage(
      "Enter your data to continue",
    ),
    "enterVerficationCode": MessageLookupByLibrary.simpleMessage(
      "Enter Verification Code",
    ),
    "explore": MessageLookupByLibrary.simpleMessage("Explore"),
    "fieldRequired": MessageLookupByLibrary.simpleMessage(
      "This field is required.",
    ),
    "filters": MessageLookupByLibrary.simpleMessage("Filters"),
    "financialSnapshotTitle": MessageLookupByLibrary.simpleMessage(
      "Booking financial summary",
    ),
    "firstName": MessageLookupByLibrary.simpleMessage("First Name"),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot Password?"),
    "fullName": MessageLookupByLibrary.simpleMessage("Full name"),
    "getStarted": MessageLookupByLibrary.simpleMessage("Get Started"),
    "governorateLabel": MessageLookupByLibrary.simpleMessage("Governorate"),
    "grossAmountLabel": MessageLookupByLibrary.simpleMessage("Gross amount"),
    "guest": MessageLookupByLibrary.simpleMessage("Guest"),
    "guestBookingOnly": MessageLookupByLibrary.simpleMessage(
      "Only Guests can request bookings",
    ),
    "guestBookingsTitle": MessageLookupByLibrary.simpleMessage("My bookings"),
    "guestBookingsUnauthorized": MessageLookupByLibrary.simpleMessage(
      "Guest bookings are not available for this account.",
    ),
    "guestCount": m2,
    "guestNameLabel": MessageLookupByLibrary.simpleMessage("Guest"),
    "guestsLabel": MessageLookupByLibrary.simpleMessage("Guests"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "homeLocation": MessageLookupByLibrary.simpleMessage("Cairo, Egypt"),
    "host": MessageLookupByLibrary.simpleMessage("Host"),
    "hostActivationFailure": MessageLookupByLibrary.simpleMessage(
      "Host activation failed. Please try again.",
    ),
    "hostActivationSuccess": MessageLookupByLibrary.simpleMessage(
      "Your account is now a Host account.",
    ),
    "hostAmountLabel": MessageLookupByLibrary.simpleMessage("Host amount"),
    "hostBookingsTitle": MessageLookupByLibrary.simpleMessage(
      "Booking requests",
    ),
    "hostBookingsUnauthorized": MessageLookupByLibrary.simpleMessage(
      "Host booking requests are only available to Hosts.",
    ),
    "hostDecisionSuccess": m3,
    "hostPropertiesTitle": MessageLookupByLibrary.simpleMessage(
      "My properties",
    ),
    "identityAuthError": MessageLookupByLibrary.simpleMessage(
      "Your session may have expired. Sign in again before submitting.",
    ),
    "identityCamera": MessageLookupByLibrary.simpleMessage("Take a photo"),
    "identityChooseImage": MessageLookupByLibrary.simpleMessage("Choose image"),
    "identityConfirmSubmit": MessageLookupByLibrary.simpleMessage(
      "Confirm and submit",
    ),
    "identityConfirmation": MessageLookupByLibrary.simpleMessage(
      "I confirm these images belong to me and are ready to submit for identity review.",
    ),
    "identityDocument": MessageLookupByLibrary.simpleMessage(
      "National ID photo",
    ),
    "identityExistingRequest": MessageLookupByLibrary.simpleMessage(
      "A verification submission already exists for your account. Its current status is shown above.",
    ),
    "identityFlowTitle": MessageLookupByLibrary.simpleMessage(
      "Identity verification",
    ),
    "identityGallery": MessageLookupByLibrary.simpleMessage(
      "Choose from gallery",
    ),
    "identityGenericError": MessageLookupByLibrary.simpleMessage(
      "Unable to submit your identity documents. Please try again.",
    ),
    "identityIdBack": MessageLookupByLibrary.simpleMessage(
      "National ID — back",
    ),
    "identityIdBackInstructions": MessageLookupByLibrary.simpleMessage(
      "Capture the back of your national ID. Keep the entire card in frame and the text readable.",
    ),
    "identityIdFront": MessageLookupByLibrary.simpleMessage(
      "National ID — front",
    ),
    "identityIdFrontInstructions": MessageLookupByLibrary.simpleMessage(
      "Capture the front of your national ID. Keep the entire card in frame and the text readable.",
    ),
    "identityImageReady": MessageLookupByLibrary.simpleMessage("Image added"),
    "identityImageUnavailable": MessageLookupByLibrary.simpleMessage(
      "This image could not be opened. Please choose it again.",
    ),
    "identityNetworkError": MessageLookupByLibrary.simpleMessage(
      "Could not connect. Your selected images are saved on this screen; please try again.",
    ),
    "identityNotSubmitted": MessageLookupByLibrary.simpleMessage(
      "Verification not submitted",
    ),
    "identityNotVerifiedForBooking": MessageLookupByLibrary.simpleMessage(
      "Identity verification is required before booking.",
    ),
    "identityPending": MessageLookupByLibrary.simpleMessage("Under review"),
    "identityPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Camera or photo access was denied. Allow access in your device settings and try again.",
    ),
    "identityPrivacyNote": MessageLookupByLibrary.simpleMessage(
      "Your images are uploaded securely only after you review and confirm them.",
    ),
    "identityRejected": MessageLookupByLibrary.simpleMessage(
      "Verification rejected",
    ),
    "identityRejectedRetryPrompt": MessageLookupByLibrary.simpleMessage(
      "Your identity verification was rejected. You can try again by uploading your documents again.",
    ),
    "identityReplaceImage": MessageLookupByLibrary.simpleMessage(
      "Retake or replace",
    ),
    "identityReview": MessageLookupByLibrary.simpleMessage("Review"),
    "identityReviewDescription": MessageLookupByLibrary.simpleMessage(
      "Make sure all three images are clear and readable before submitting.",
    ),
    "identityReviewTitle": MessageLookupByLibrary.simpleMessage(
      "Review your photos",
    ),
    "identitySelfie": MessageLookupByLibrary.simpleMessage("Selfie"),
    "identitySelfieInstructions": MessageLookupByLibrary.simpleMessage(
      "Take a clear photo of your face in good lighting. Make sure your face is fully visible.",
    ),
    "identityServerError": MessageLookupByLibrary.simpleMessage(
      "The service is temporarily unavailable. Your selected images are still here; try again later.",
    ),
    "identitySubmissionPending": MessageLookupByLibrary.simpleMessage(
      "Your documents were sent successfully. Submission does not mean your identity has been approved.",
    ),
    "identitySubmissionReceived": MessageLookupByLibrary.simpleMessage(
      "Submission received",
    ),
    "identityTryAgain": MessageLookupByLibrary.simpleMessage("Try Again"),
    "identityUnknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "identityUploading": MessageLookupByLibrary.simpleMessage("Uploading…"),
    "identityValidationError": MessageLookupByLibrary.simpleMessage(
      "The server could not accept these images. Check them and try again.",
    ),
    "identityVerification": MessageLookupByLibrary.simpleMessage(
      "Identity verification",
    ),
    "identityVerified": MessageLookupByLibrary.simpleMessage("Verified"),
    "imageSelectionCount": MessageLookupByLibrary.simpleMessage(
      "images selected",
    ),
    "increaseGuests": MessageLookupByLibrary.simpleMessage("Increase guests"),
    "instapayConfigurationMissing": MessageLookupByLibrary.simpleMessage(
      "Official InstaPay account information is not configured in the app yet. Do not transfer funds until it is available.",
    ),
    "instapayInstructions": MessageLookupByLibrary.simpleMessage(
      "Transfer the exact booking amount through InstaPay, then upload a clear screenshot of the receipt.",
    ),
    "invalidCount": MessageLookupByLibrary.simpleMessage(
      "Enter a valid whole-number count.",
    ),
    "invalidDateRange": MessageLookupByLibrary.simpleMessage(
      "Check-out must be later than check-in.",
    ),
    "invalidEgyptianMobile": MessageLookupByLibrary.simpleMessage(
      "Enter a valid Egyptian mobile number.",
    ),
    "invalidLatitude": MessageLookupByLibrary.simpleMessage(
      "Latitude must be between -90 and 90.",
    ),
    "invalidLongitude": MessageLookupByLibrary.simpleMessage(
      "Longitude must be between -180 and 180.",
    ),
    "invalidPositiveNumber": MessageLookupByLibrary.simpleMessage(
      "Enter a valid number greater than zero.",
    ),
    "lastName": MessageLookupByLibrary.simpleMessage("Last Name"),
    "latitudeLabel": MessageLookupByLibrary.simpleMessage("Latitude"),
    "loadMore": MessageLookupByLibrary.simpleMessage("Load more"),
    "loadingAccount": MessageLookupByLibrary.simpleMessage(
      "Loading your account...",
    ),
    "location": MessageLookupByLibrary.simpleMessage("Location"),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "loginSuccessfull": MessageLookupByLibrary.simpleMessage("Login Success"),
    "loginToBook": MessageLookupByLibrary.simpleMessage(
      "Log in to request booking",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("Log out"),
    "logoutConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to log out?",
    ),
    "logoutFailed": MessageLookupByLibrary.simpleMessage(
      "Unable to log out. Please try again.",
    ),
    "longitudeLabel": MessageLookupByLibrary.simpleMessage("Longitude"),
    "map": MessageLookupByLibrary.simpleMessage("Map"),
    "messages": MessageLookupByLibrary.simpleMessage("Messages"),
    "minimumImagesRequired": MessageLookupByLibrary.simpleMessage(
      "minimum 4 images",
    ),
    "monthly": MessageLookupByLibrary.simpleMessage("Monthly"),
    "myHome": MessageLookupByLibrary.simpleMessage("My Home"),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "night": MessageLookupByLibrary.simpleMessage("night"),
    "nightlyPriceLabel": MessageLookupByLibrary.simpleMessage("Nightly price"),
    "noGuestBookings": MessageLookupByLibrary.simpleMessage(
      "You have no bookings yet.",
    ),
    "noHostBookings": MessageLookupByLibrary.simpleMessage(
      "There are no pending booking requests.",
    ),
    "noHostProperties": MessageLookupByLibrary.simpleMessage(
      "You haven\'t listed any properties yet.",
    ),
    "noPropertiesFound": MessageLookupByLibrary.simpleMessage(
      "No properties match your search",
    ),
    "notAvailable": MessageLookupByLibrary.simpleMessage("Not available"),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "onBoardingDescription": MessageLookupByLibrary.simpleMessage(
      "Discover the best housing available in your area with ease and speed",
    ),
    "onBoardingDescription2": MessageLookupByLibrary.simpleMessage(
      "Connect directly with the owner and book the perfect accommodation for you safely",
    ),
    "onBoardingDescription3": MessageLookupByLibrary.simpleMessage(
      "Enjoy your stay in the accommodation you chose and have an unforgettable experience",
    ),
    "onBoardingTitle": MessageLookupByLibrary.simpleMessage("Search Easily"),
    "onBoardingTitle2": MessageLookupByLibrary.simpleMessage(
      "Book with Confidence",
    ),
    "onBoardingTitle3": MessageLookupByLibrary.simpleMessage("Enjoy Your Stay"),
    "otpCodeRequired": MessageLookupByLibrary.simpleMessage(
      "Enter the complete six-digit code.",
    ),
    "otpGenericError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t complete that request. Please try again.",
    ),
    "otpInvalidOrExpired": MessageLookupByLibrary.simpleMessage(
      "This code is invalid or expired. Check it and try again.",
    ),
    "otpNetworkError": MessageLookupByLibrary.simpleMessage(
      "Could not connect. Check your connection and try again.",
    ),
    "otpResendAvailableIn": MessageLookupByLibrary.simpleMessage(
      "Resend code in",
    ),
    "otpResendSuccess": MessageLookupByLibrary.simpleMessage(
      "A new verification code has been sent.",
    ),
    "otpResending": MessageLookupByLibrary.simpleMessage(
      "Sending a new code...",
    ),
    "otpServerError": MessageLookupByLibrary.simpleMessage(
      "The service is temporarily unavailable. Please try again later.",
    ),
    "otpVerificationSuccess": MessageLookupByLibrary.simpleMessage(
      "Email verified. Please sign in to continue.",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "paymentHeld": MessageLookupByLibrary.simpleMessage("Held"),
    "paymentInstructionsTitle": MessageLookupByLibrary.simpleMessage(
      "InstaPay payment",
    ),
    "paymentReceiptChoose": MessageLookupByLibrary.simpleMessage(
      "Choose receipt image",
    ),
    "paymentReceiptFormatError": MessageLookupByLibrary.simpleMessage(
      "Only JPG and PNG receipt images are supported.",
    ),
    "paymentReceiptImageError": MessageLookupByLibrary.simpleMessage(
      "Could not open the selected image.",
    ),
    "paymentReceiptLabel": MessageLookupByLibrary.simpleMessage(
      "Payment receipt",
    ),
    "paymentReceiptMissing": MessageLookupByLibrary.simpleMessage(
      "No receipt image was returned for this payment.",
    ),
    "paymentReceiptReplace": MessageLookupByLibrary.simpleMessage(
      "Replace receipt image",
    ),
    "paymentReceiptSelectFirst": MessageLookupByLibrary.simpleMessage(
      "Select a receipt image first.",
    ),
    "paymentReceiptSelectImage": MessageLookupByLibrary.simpleMessage(
      "Select an InstaPay screenshot",
    ),
    "paymentReceiptSizeError": MessageLookupByLibrary.simpleMessage(
      "The receipt image must be 10 MB or smaller.",
    ),
    "paymentReceiptSubmit": MessageLookupByLibrary.simpleMessage(
      "Submit receipt",
    ),
    "paymentReceiptSubmitted": MessageLookupByLibrary.simpleMessage(
      "Receipt submitted successfully. It is waiting for Admin review.",
    ),
    "paymentReceiptUploadError": MessageLookupByLibrary.simpleMessage(
      "Could not submit the receipt. Please try again.",
    ),
    "paymentReceiptUploading": MessageLookupByLibrary.simpleMessage(
      "Uploading receipt...",
    ),
    "paymentRefunded": MessageLookupByLibrary.simpleMessage("Refunded"),
    "paymentStatusLabel": MessageLookupByLibrary.simpleMessage(
      "Payment status",
    ),
    "paymentUploadButton": MessageLookupByLibrary.simpleMessage(
      "Pay with InstaPay",
    ),
    "personalInfo": MessageLookupByLibrary.simpleMessage(
      "Personal information",
    ),
    "phone": MessageLookupByLibrary.simpleMessage("Phone"),
    "phoneProfileUnavailable": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t load your profile details. Please try again before updating your number.",
    ),
    "phoneRequired": MessageLookupByLibrary.simpleMessage(
      "Enter your phone number.",
    ),
    "phoneUpdateAuthError": MessageLookupByLibrary.simpleMessage(
      "Your session may have expired. Sign in again and retry.",
    ),
    "phoneUpdateGenericError": MessageLookupByLibrary.simpleMessage(
      "Could not update your phone number. Please try again.",
    ),
    "phoneUpdateNetworkError": MessageLookupByLibrary.simpleMessage(
      "Could not connect. Check your connection and try again.",
    ),
    "phoneUpdateServerError": MessageLookupByLibrary.simpleMessage(
      "The service is temporarily unavailable. Try again later.",
    ),
    "phoneUpdateSuccess": MessageLookupByLibrary.simpleMessage(
      "Phone number updated successfully.",
    ),
    "phoneUpdateValidationError": MessageLookupByLibrary.simpleMessage(
      "The phone number was not accepted. Check it and try again.",
    ),
    "profileRefreshError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t refresh your profile. Check your connection and try again.",
    ),
    "propertiesLoadError": MessageLookupByLibrary.simpleMessage(
      "Could not load properties. Check your connection and try again.",
    ),
    "propertyCapacity": m4,
    "propertyCreating": MessageLookupByLibrary.simpleMessage(
      "Creating property…",
    ),
    "propertyCreationIdMissing": MessageLookupByLibrary.simpleMessage(
      "The server did not return a property ID. The property will not be created again automatically.",
    ),
    "propertyDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "Description",
    ),
    "propertyDetailsTitle": MessageLookupByLibrary.simpleMessage(
      "Property details",
    ),
    "propertyFamilyApartment": MessageLookupByLibrary.simpleMessage(
      "Family apartment",
    ),
    "propertyFurnishedApartment": MessageLookupByLibrary.simpleMessage(
      "Furnished apartment near services",
    ),
    "propertyImagesLabel": MessageLookupByLibrary.simpleMessage(
      "Property images",
    ),
    "propertyLocationGiza": MessageLookupByLibrary.simpleMessage("Giza, Egypt"),
    "propertyLocationNasrCity": MessageLookupByLibrary.simpleMessage(
      "Nasr City, Egypt",
    ),
    "propertyLocationNewCairo": MessageLookupByLibrary.simpleMessage(
      "New Cairo, Egypt",
    ),
    "propertyModernApartment": MessageLookupByLibrary.simpleMessage(
      "Modern apartment with a stunning view",
    ),
    "propertyStatusMissing": MessageLookupByLibrary.simpleMessage(
      "The server did not return the resulting status.",
    ),
    "propertySubmissionSuccess": MessageLookupByLibrary.simpleMessage(
      "Property submitted with status:",
    ),
    "propertySubmitting": MessageLookupByLibrary.simpleMessage(
      "Submitting for review…",
    ),
    "propertyTitleLabel": MessageLookupByLibrary.simpleMessage(
      "Property title",
    ),
    "propertyUploading": MessageLookupByLibrary.simpleMessage(
      "Uploading images…",
    ),
    "propertyWorkflowError": MessageLookupByLibrary.simpleMessage(
      "The operation failed. Review the details and retry.",
    ),
    "refreshProfile": MessageLookupByLibrary.simpleMessage("Refresh profile"),
    "register": MessageLookupByLibrary.simpleMessage("Create Account"),
    "registerNewAcc": MessageLookupByLibrary.simpleMessage(
      "Register New Account",
    ),
    "rejectBooking": MessageLookupByLibrary.simpleMessage("Reject"),
    "rejectBookingConfirmation": MessageLookupByLibrary.simpleMessage(
      "The booking will be rejected and the backend will handle any refund.",
    ),
    "rejectBookingTitle": MessageLookupByLibrary.simpleMessage(
      "Reject booking request?",
    ),
    "removeFromFavorites": MessageLookupByLibrary.simpleMessage(
      "Remove from favorites",
    ),
    "removePropertyImage": MessageLookupByLibrary.simpleMessage("Remove image"),
    "requestBooking": MessageLookupByLibrary.simpleMessage("Request booking"),
    "resendCode": MessageLookupByLibrary.simpleMessage("Resend code"),
    "resetFilters": MessageLookupByLibrary.simpleMessage("Reset filters"),
    "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "roleRequired": MessageLookupByLibrary.simpleMessage(
      "Choose an account type to continue.",
    ),
    "roomsLabel": MessageLookupByLibrary.simpleMessage("Rooms"),
    "savePhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Save phone number",
    ),
    "search": MessageLookupByLibrary.simpleMessage("Search..."),
    "selectBookingDates": MessageLookupByLibrary.simpleMessage(
      "Select check-in and check-out dates.",
    ),
    "selectBothDates": MessageLookupByLibrary.simpleMessage(
      "Select both check-in and check-out dates.",
    ),
    "selectDate": MessageLookupByLibrary.simpleMessage("Select date"),
    "serviceFeeLabel": MessageLookupByLibrary.simpleMessage("Service fee"),
    "skip": MessageLookupByLibrary.simpleMessage("Skip"),
    "submitProperty": MessageLookupByLibrary.simpleMessage(
      "Create and submit for review",
    ),
    "unknownStatus": MessageLookupByLibrary.simpleMessage("Unknown status"),
    "verify": MessageLookupByLibrary.simpleMessage("Verify"),
  };
}
