import Foundation

extension String {
  var localized: String { return NSLocalizedString(self, comment: self) }
/* 
  Localizable.strings
  CSMall

  Created by taoh on 2018/3/5.
  Copyright © 2018年 taoh. All rights reserved.
*/
/**App底部分栏图标上显示的文字**/
  static var localized_Mall: String { return "Mall".localized }
  static var localized_Classification: String { return "Classification".localized }
  static var localized_Shoppingcart: String { return "Shopping cart".localized }
  static var localized_Me: String { return "Me".localized }

/**我的页面显示的文字**/
  static var localized_Pendingpayment: String { return "payment";//"Pending payment".localized }
  static var localized_Waitingfordelivery: String { return "delivery";//"Waiting for delivery".localized }
  static var localized_Waitingforreceipt: String { return "receipt";//"Waiting for receipt".localized }
  static var localized_Waitingforevaluation: String { return "evaluation";//"Waiting for evaluation".localized }
  static var localized_Refund: String { return "Refund".localized }
  static var localized_Myaccount: String { return "My account".localized }
  static var localized_Mycollection: String { return "My collection".localized }
  static var localized_Myinteresting: String { return "My interesting".localized }
  static var localized_Myaddress: String { return "My address".localized }
  static var localized_Mydiscountcoupon: String { return "My discount coupon".localized }
  static var localized_Applyforashop"  = "Apply for a shop".localized }
  static var localized_Set: String { return "Set".localized }
  static var localized_Help: String { return "Help".localized }
  static var localized_Aboutus: String { return "About us".localized }
  static var localized_AccountBalance: String { return "Account Balance".localized }
  static var localized_Rechargerecord: String { return "Recharge record".localized }
  static var localized_Giveaway: String { return "Give away".localized }
  static var localized_Rechargelist: String { return "Recharge list".localized }
  static var localized_Unlink: String { return "unlink".localized }
  static var localized_Monthlysales: String { return "Monthly sales".localized }
  static var localized_Cancelall: String { return "Cancel all".localized }
  static var localized_Addnewaddress: String { return "Add new address".localized }
  static var localized_Delete: String { return "Delete".localized }
  static var localized_Edit: String { return "Edit".localized }
  static var localized_SetasDefaultaddress: String { return "Set as Default address".localized }
  static var localized_Defaultaddress: String { return "Default address".localized }
  static var localized_Used: String { return "Used".localized }
  static var localized_Unused: String { return "Unused".localized }
  static var localized_Expired: String { return "Expired".localized }
  static var localized_Submitapplication: String { return "Submit application".localized }
  static var localized_Auditingdetails: String { return "Auditing details".localized }
  static var localized_Auditing: String { return "Auditing".localized }
  static var localized_Pass: String { return "Pass".localized }
  static var localized_Deposit: String { return "Deposit".localized }
  static var localized_Name: String { return "Name".localized }
  static var localized_ContactTel: String { return "Contact Tel.".localized }
  static var localized_CompanyID: String { return "Company ID".localized }
  static var localized_ShopName: String { return "Shop Name".localized }
  static var localized_Shopaddress: String { return "Shop address".localized }
  static var localized_IDcard: String { return "ID card".localized }
  static var localized_UniqueIDcodeofcompany: String { return "Unique ID code of company".localized }
  static var localized_Somethingwrong: String { return "Something wrong?".localized }
  static var localized_Contact: String { return "Contact".localized }
  static var localized_Personalinformation: String { return "Personal information".localized }
  static var localized_Editaddress: String { return "Edit address".localized }
  static var localized_Erase: String { return "Erase".localized }
  static var localized_Feedback: String { return "Feedback".localized }
  static var localized_Signout: String { return "Sign out".localized }
  static var localized_Total: String { return "Total".localized }
  static var localized_Settlement: String { return "Settlement".localized }
  static var localized_Selectall: String { return "Select all".localized }
  static var localized_Systemmessage: String { return "System message".localized }
  static var localized_Ordermessage: String { return "Order message".localized }
  static var localized_ProductShipped: String { return "Product Shipped".localized }
  static var localized_OrderNumber: String { return "Order Number".localized }
  static var localized_Pleaseentertheproducttosearch: String { return "Please enter the product to search".localized }
  static var localized_PleaseentertheshopnameandID: String { return "Please enter the shop name and ID".localized }
  static var localized_Goldenshop: String { return "Golden shop".localized }
  static var localized_Sorting: String { return "Sorting".localized }
  static var localized_Sales: String { return "Sales".localized }
  static var localized_Price: String { return "Price".localized }
/**百度**/
  static var localized_Paymentsuccess: String { return "Payment success".localized }
  static var localized_Paymentfailurepleaserepay: String { return "Payment failure, please repay".localized }
  static var localized_Pleasechoosethewayofpayment: String { return "Please choose the way of payment".localized }
  static var localized_WeChat: String { return "WeChat".localized }
  static var localized_Alipay: String { return "Alipay".localized }
  static var localized_Cancel: String { return "Cancel".localized }
  static var localized_Theinformationisasfollows: String { return "The information is as follows".localized }
  static var localized_Rejected: String { return "Rejected".localized }
  static var localized_Auditing: String { return "Auditing".localized }
  static var localized_Applicationforrefund: String { return "Application for refund".localized }
  static var localized_Number: String { return "Number".localized }
  static var localized_Reasonsforrefunds: String { return "Reasons for refunds".localized }
  static var localized_Notconnected: String { return "Sorry, it can't be connected for the time being".localized }
  static var localized_Immediatedelivery: String { return "Immediate delivery".localized }
  static var localized_Businessentryapplication: String { return "Business entry application".localized }
  static var localized_UploadIDcard: String { return "Upload ID card (please keep the document content clear)".localized }
  static var localized_UniqueIDcodeofcompany: String { return "Upload Unique ID code of company".localized }
  static var localized_Uploadingfromthealbum: String { return "Uploading from the album".localized }
  static var localized_takeaphoto: String { return "take a photo".localized }
  static var localized_Pleaseuploadthedocumentsasrequired: String { return "Please upload the documents as required".localized }
  static var localized_UploadError: String { return "Upload an error, please reupload the picture".localized }
  static var localized_Pleasechoosethecity: String { return "Please choose the city in which it is located".localized }
  static var localized_Pleaseenterthecorrectphonenumber: String { return "Please enter the correct phone number".localized }
  static var localized_Next: String { return "Next step".localized }
  static var localized_Fillininformation: String { return "Fill in information".localized }
  static var localized_Businessadmissionagreement: String { return "Business admission agreement".localized }
  static var localized_Pleaseenteryourname: String { return "Please enter your name".localized }
  static var localized_PleaseenteryourcontactTel: String { return "Please enter your contact Tel".localized }
  static var localized_Name: String { return "Name：".localized }
  static var localized_Hint_01: String { return "The specifications are incorrect here".localized }
  static var localized_Hint_02: String { return "Stock".localized }
  static var localized_Hint_03: String { return "Please choose".localized }
  static var localized_Hint_04: String { return "I'm sorry that the goods have been sold out.".localized }
  static var localized_Hint_05: String { return "Add success! The goods are in the shopping cart.".localized }
  static var localized_Hint_06: String { return "Non specification".localized }
  static var localized_Hint_07: String { return "Purchase immediately".localized }
  static var localized_Hint_08: String { return "Add to cart".localized }
  static var localized_Hint_09: String { return "Selected".localized }
  static var localized_Hint_10: String { return "piece".localized }
  static var localized_Hint_11: String { return "Specification: no".localized }
  static var localized_Hint_12: String { return "A commodity can't be less than one".localized }
  static var localized_Hint_13: String { return "Lack of stock".localized }
  static var localized_Hint_14: String { return "Confirmation of order".localized }
  static var localized_Hint_15: String { return "have access to".localized }
  static var localized_Hint_16: String { return "Deductible".localized }
  static var localized_Hint_17: String { return "Please choose the receiving address".localized }
  static var localized_Hint_18: String { return "Payment failure, please repay".localized }
  static var localized_Hint_19: String { return "Total".localized }
  static var localized_Hint_20: String { return "Piece goods".localized }
  static var localized_Hint_21: String { return "Small plan".localized }
  static var localized_Hint_22: String { return "Shop introduction".localized }
  static var localized_Hint_23: String { return "Business phone".localized }
  static var localized_Hint_24: String { return "The area in which it is located".localized }
  static var localized_Hint_25: String { return "Store time".localized }
  static var localized_Hint_26: String { return "Check the license qualification".localized }
  static var localized_Hint_27: String { return "Platform message".localized }
  static var localized_Hint_28: String { return "Wonderful playback".localized }
  static var localized_Hint_29: String { return "The classification is wrong".localized }
  static var localized_Hint_30: String { return "Well！ Your friend".localized }
  static var localized_Hint_31: String { return "share".localized }
  static var localized_Hint_32: String { return "Is getting information on goods".localized }
  static var localized_Hint_33: String { return "commodity".localized }
  static var localized_Hint_34: String { return "details".localized }
  static var localized_Hint_35: String { return "evaluate".localized }
  static var localized_Hint_36: String { return "Collection".localized }
  static var localized_Hint_37: String { return "Already collected".localized }
  static var localized_Hint_38: String { return "All comments".localized }
  static var localized_Hint_39: String { return "Person purchase".localized }
  static var localized_Hint_40: String { return "playback".localized }
  static var localized_Hint_41: String { return "Upload time".localized }
  static var localized_Hint_42: String { return "There's nothing in the shopping cart.".localized }
  static var localized_Hint_43: String { return "complete".localized }
  static var localized_Hint_44: String { return "all".localized }
  static var localized_Hint_45: String { return "Successful trade".localized }
  static var localized_Hint_46: String { return "Contact";//Contact the merchant
  static var localized_Hint_47: String { return "payment".localized }
  static var localized_Hint_48: String { return "Order details".localized }
  static var localized_Hint_49: String { return "Waiting for the buyer to pay".localized }
  static var localized_Hint_50: String { return "After no payment, the order will be automatically closed!".localized }
  static var localized_Hint_51: String { return "Cancellation".localized }
  static var localized_Hint_52: String { return "Reminder".localized }
  static var localized_Hint_53: String { return "Waiting for shipments to be shipped".localized }
  static var localized_Hint_54: String { return "Please wait patiently in your package.".localized }
  static var localized_Hint_55: String { return "receipt".localized }
  static var localized_Hint_56: String { return "logistics".localized }
  static var localized_Hint_57: String { return "The merchant has shipped the goods".localized }
  static var localized_Hint_58: String { return "Your merchandise has been loaded with rockets and is coming to you quickly.".localized }
  static var localized_Hint_59: String { return "evaluate".localized }
  static var localized_Hint_60: String { return "The buyer has confirmed the receipt".localized }
  static var localized_Hint_61: String { return "Confirmed".localized }
  static var localized_Hint_62: String { return "Please fill in the comments.".localized }
  static var localized_Hint_63: String { return "Please fill in the comment information.".localized }
  static var localized_Hint_64: String { return "Comment on success".localized }
  static var localized_Hint_65: String { return "Congratulations！ The payment was successful.".localized }
  static var localized_Hint_66: String { return "View the order".localized }
  static var localized_Hint_67: String { return "I'm sorry！ The payment failed!".localized }
  static var localized_Hint_68: String { return "Please check your network or try again later".localized }
  static var localized_Hint_69: String { return "Continue payment".localized }
  static var localized_Hint_70: String { return "total".localized }
  static var localized_Hint_71: String { return "Piece goods".localized }
  static var localized_Hint_72: String { return "Have received the goods".localized }
  static var localized_Hint_73: String { return "Distribution".localized }
  static var localized_Hint_74: String { return "Problem parts".localized }
  static var localized_Hint_75: String { return "Store score".localized }
  static var localized_Hint_76: String { return "Logistics score".localized }
  static var localized_Hint_77: String { return "Service score".localized }
  static var localized_Hint_78: String { return "Sure".localized }
  static var localized_Hint_79: String { return "Loading".localized }
  static var localized_Hint_80: String { return "Please enter the evaluation of the goods".localized }
  static var localized_Hint_81: String { return "After sale details".localized }
  static var localized_Hint_82: String { return "Apply for after sale".localized }
  static var localized_Hint_83: String { return "Please enter the correct cell phone number".localized }
  static var localized_Hint_84: String { return "Commodity Description".localized }
  static var localized_Hint_85: String { return "Seller description".localized }
  static var localized_Hint_86: String { return "Logistics service".localized }
  static var localized_Hint_87: String { return "Enter the shop".localized }
  static var localized_Hint_88: String { return "follow".localized }
  static var localized_Hint_89: String { return "Focus on".localized }
  static var localized_Hint_90: String { return "Please enter the goods to be searched".localized }
  static var localized_Hint_91: String { return "Please enter the name of the shop, the merchant ID".localized }
  static var localized_Hint_92: String { return "Pick of the week".localized }



  static var localized_Hint_201: String { return "send way".localized }
  static var localized_Hint_202: String { return "send fast".localized }
  static var localized_Hint_203: String { return "saller word".localized }
  static var localized_Hint_204: String { return "ticket discount".localized }
  static var localized_Hint_205: String { return "score discount".localized }
  static var localized_Hint_206: String { return "mine message".localized }
  static var localized_Hint_207: String { return "address manager".localized }
  static var localized_Hint_208: String { return "feed back".localized }
  static var localized_Hint_209: String { return "clear memory".localized }
  static var localized_Hint_210: String { return "system message".localized }
  static var localized_Hint_211: String { return "order message".localized }
  static var localized_Hint_212: String { return "head image".localized }
  static var localized_Hint_213: String { return "phone num".localized }
  static var localized_Hint_214: String { return "nick name".localized }
  static var localized_Hint_215: String { return "sex".localized }
  static var localized_Hint_216: String { return "sign".localized }

}
