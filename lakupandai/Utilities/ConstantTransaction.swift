//
//  ConstantTransaction.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 04/10/23.
//

import Foundation

struct ConstantTransaction {
    //ERROR RETURN
    static let CONNECTION_LOST: String = "Koneksi Timeout"
    static let CONNECTION_ERROR: String = "Koneksi Error"
    static let SERVER_ERROR: String = "Server Error"
    static let SERVER_RETURN_EMPTY_DATA: String = "Halaman kosong"
    
    
    //JSON RESULT
    static let RC_RESULT: String = "RC"
    static let RM_RESULT: String = "RM"
    static let DATA: String = "data"
    static let SUCCESS_CODE: String = "00"
    static let RESET_CODE: String = "02"
    static let LAST_LOGIN: String = "last_login"
    
    //BUNDLE
    static let BUNDLE_NOKTP: String = "NoKTP"
    static let BUNDLE_NAMA: String = "Nama"
    static let BUNDLE_NOHP: String = "NoHP"
    static let BUNDLE_PIN: String = "PIN"
    static let BUNDLE_TGL: String = "TGL"
    static let BUNDLE_RC: String = "RC"
    static let BUNDLE_RM: String = "RM"
    static let BUNDLE_TOKEN: String = "token"
    static let BUNDLE_ARRAY_LIST: String = "arraylist"
    static let BUNDLE_TITLE: String = "TITLE"
    static let BUNDLE_TITLE_REK_BARU: String = "Aktivasi Rekening Baru"
    static let BUNDLE_TITLE_TARIK_TUNAI: String = "Tarik Tunai"
    static let BUNDLE_TITLE_KONF_TARIK_TUNAI: String = "Konfirmasi Tarik Tunai"
    static let BUNDLE_TITLE_CEK_STATUS_TERAKHIR: String = "Cek Status Terakhir"
    static let BUNDLE_TITLE_CEK_SALDO_AGEN: String = "Cek Saldo Agen"
    static let BUNDLE_TITLE_CEK_SALDO_NASABAH: String = "Cek Saldo Nasabah"
    static let BUNDLE_TITLE_SETOR_TUNAI: String = "Setor Tunai"
    static let BUNDLE_TITLE_PEMBELIAN: String = "Pembelian"
    static let BUNDLE_TITLE_PEMBAYARAN: String = "Pembayaran"
    static let BUNDLE_TITLE_PEMBELIAN_PULSA: String = "Pembelian Pulsa"
    static let BUNDLE_TITLE_TRANSFER: String = "Transfer"
    static let ACTION: String = "action"
    static let TOKEN: String = "token"
    //AGENT
    //JSON CEK SALDO AGEN
    static let MSISDN_AGEN_CEK_SALDO_AGEN: String = "msisdn_agen"
    static let PIN_CEK_SALDO_AGEN: String = "pin"
    static let ACTION_CEK_SALDO_AGEN: String = "saldo_agen"
    static let MESSAGE_LOG_CEK_SALDO_AGEN: String = "Mencoba Cek Saldo Agen"
    static let LOG_CEK_SALDO_AGEN: String = "Request Cek Saldo Agen"
    
    //JSON LOGIN
    static let SIM_SERIAL_LOGIN: String = "simserial"
    static let PIN_LOGIN: String = "pin"
    static let MSISDN_AGEN_LOGIN: String = "msisdn_agen"
    static let IMEI_LOGIN: String = "imei"
    static let ACTION_LOGIN: String = "login"
    static let ACTION_INIT: String = "initialize"
    static let MESSAGE_LOG_LOGIN: String = "Mencoba Login"
    static let LOG_LOGIN: String = "Request Login"
    
    static let TimeOutConnection: Int = 420000
    
    //     static final let URL = "https://bb.bpddiy.co.id/lakupandaidiy/"
    
    //dev DIY
//    static let URL: String = "https://103.23.175.124:8442/lakupandaidiy/"
    
    //dev DAK
//    static let URL: String = "https://103.79.130.194:7818/lakupandaidiy/"
    static let URL: String = "https://103.79.130.194:10010/lakupandaidiy/"
    
    static let MESSAGE_OK:String = "Ok"
    static let MESSAGE:String = "Pesan"
    static let MESSAGE_ROOT :String = "Aplikasi tidak bisa digunakan bila Root Device Aktif"
    
    static let MSISDN_AGEN:String = "msisdn_agen"
    static let RESET_PASS :String = "reset_pwd"
    
    //ALERT DIALOG
    static let MESSAGE_LOGOUT :String = "Anda Yakin Ingin Keluar?"
    static let MESSAGE_SMS :String = "Data Akan Dikirim Lewat SMS Karena Masalah Jaringan, Ijinkan?"
    static let MESSAGE_YES :String = "Ya"
    static let MESSAGE_NO :String = "Tidak"
    static let MESSAGE_FAILED :String = "Gagal Mengirim Data Harap Dicoba Kembali"
    
    
    //JSON MUTASI
    static let START_DATE :String = "start_date"
    static let END_DATE :String = "end_date"
    static let ACTION_MUTASI :String = "history_trx"
    static let PAGE_JSON :String = "page"
    static let EMPTY_TRANSACTION_RESULT :String = "Transaksi tidak ditemukan !"
    
    //JSON PEMBAYRAN/PEMBELIAN
    static let KODE_PRODUK :String = "product_code"
    static let ID_PELANGGAN :String = "id_pelanggan"
    static let MSISDN_NASABAH :String = "hp_nasabah"
    static let MSISDN_NASABAH_INQ :String = "msisdn_nasabah"
    static let ACTION_PEMBAYARAN :String = "inquiry_payment"
    static let ACTION_PEMBELIAN :String = "inquiry_prepaid"
    static let ACTION_KONFIRMASI_PEMBELIAN :String = "posting_prepaid"
    static let ACTION_KONFIRMASI_PEMBAYARAN :String = "posting_payment"
    static let ACTION_GET_MENU :String = "get_menu"
    static let PIN_PEMBAYARAN :String = "pin"
    static let TIPE :String = "tipe"
    static let DENOM :String = "denom"
    static let LAYANAN: String = ""
    
    //ALERT TIMEOUT
    static let MESSAGE_TIMEOUT :String = "Sesi Anda Telah Berakhir"
    static let DISPLAY_DATA: Int = 1
    static let TimeOutApps: Int = 6000000
    // static final int TimeOutApps = 6000
    
    //JSON REK BARU
    static let NO_KTP_REK_BARU :String = "nik"
    static let NAMA_REK_BARU :String = "nama"
    static let TANGGAL_REK_BARU :String = "tanggal"
    static let MSISDN_AGEN_REK_BARU :String = "msisdn_agen"
    static let MSISDN_NASABAH_REK_BARU :String = "msisdn_nasabah"
    static let PIN_REK_BARU :String = "pin"
    static let ACTION_REK_BARU :String = "pendaftaran_rekening"
    static let ACTION_GENERATE_TOKEN :String = "generate_token_activate_account"
    static let CHECK_NIK :String = "check_nik"
    static let MESSAGE_LOG_REK_BARU :String = "Mencoba Registrasi Rek Baru"
    static let LOG_REK_BARU :String = "Request Aktivasi Rek Baru"
    static let TOKEN_REK_BARU :String = "token"
    
    
    //JSON CEK SALDO NASABAH
    static let MSISDN_AGEN_CEK_SALDO_NASABAH :String = "msisdn_agen"
    static let MSISDN_NASABAH_CEK_SALDO_NASABAH :String = "msisdn_nasabah"
    static let PIN_CEK_SALDO_NASABAH :String = "pin"
    static let ACTION_CEK_SALDO_NASABAH :String = "saldo_nasabah"
    static let MESSAGE_LOG_CEK_SALDO_NASABAH :String = "Mencoba Cek Saldo Nasabah"
    static let LOG_CEK_SALDO_NASABAH :String = "Request Cek Saldo Agen"
    
    
    //JSON CEK STATUS TERAKHIR
    static let MSISDN_AGEN_CEK_STATUS_TERAKHIR :String = "msisdn_agen"
    static let MSISDN_NASABAH_CEK_STATUS_TERAKHIR :String = "msisdn_nasabah"
    static let PIN_CEK_STATUS_TERAKHIR :String = "pin"
    static let ACTION_CEK_STATUS_TERAKHIR :String = "last_trx"
    static let MESSAGE_LOG_CEK_STATUS_TERAKHIR :String = "Mencoba Konfirmasi Tarik Tunai Token dan Pin"
    static let LOG_CEKSTATUSTERAKHIR :String = "Request Konfirmasi Tarik Tunai Token dan Pin"
    
    //JSON SETOR TUNAI
    static let MSISDN_AGEN_SETOR_TUNAI :String = "msisdn_agen"
    static let REK_NASABAH :String = "rek_nasabah"
    static let MSISDN_NASABAH_SETOR_TUNAI :String = "msisdn_nasabah"
    static let NOMINAL_SETOR_TUNAI :String = "nominal"
    static let NO_REK_SETOR_TUNAI :String = "no_rekening"
    static let TOKEN_SETOR_TUNAI :String = "token"
    static let ACTION_SETOR_TUNAI :String = "request_setor_tunai"
    static let ACTION_SETOR_TUNAI_REGULER :String = "request_setor_tunai_non_bsa"
    static let MESSAGE_LOG_SETOR_TUNAI :String = "Mencoba Setor Tunai"
    static let LOG_SETOR_TUNAI :String = "Request Setor Tunai"
    
    //JSON KONFIRMASI SETOR TUNAI
    static let MSISDN_AGEN_KONF_SETOR_TUNAI :String = "msisdn_agen"
    static let TOKEN_KONF_SETOR_TUNAI :String = "token"
    static let PIN_KONF_SETOR_TUNAI :String = "pin"
    static let ACTION_KONFIRMASI_SETOR_TUNAI :String = "posting_setor_tunai"
    static let ACTION_KONFIRMASI_SETOR_TUNAI_REGULER :String = "posting_setor_tunai_non_bsa"
    static let MESSAGE_LOG_KONF_SETOR_TUNAI :String = "Mencoba Konfirmasi Setor Tunai"
    static let LOG_KONF_SETOR_TUNAI :String = "Request Konfirmasi Setor Tunai"
    
    //JSON TARIK TUNAI
    static let MSISDN_NASABAH_TARIK_TUNAI :String = "msisdn_nasabah"
    static let NOMINAL_TARIK_TUNAI :String = "nominal"
    static let PIN_TARIK_TUNAI :String = "pin"
    static let MSISDN_AGEN_TARIK_TUNAI :String = "msisdn_agen"
    static let ACTION_TARIK_TUNAI :String = "request_tarik_tunai"
    static let MESSAGE_LOG_TARIK_TUNAI :String = "Mencoba Tarik Tunai"
    static let LOG_TARIK_TUNAI :String = "Request Tarik Tunai"
    
    
    //JSON KONFIRMASI TARIK TUNAI
    static let MSISDN_AGEN_KONF_TARIK_TUNAI :String = "msisdn_agen"
    static let TOKEN_KONF_TARIK_TUNAI :String = "token"
    static let ACTION_KONFIRMASI_TARIK_TUNAI :String = "send_token_tarik_tunai"
    static let MESSAGE_LOG_KONFIRMASI_TARIK_TUNAI :String = "Mencoba Konfirmasi Tarik Tunai"
    static let LOG_KONFIRMASI_TARIK_TUNAI :String = "Request Konfirmasi Tarik Tunai"
    
    
    //JSON KONFIRMASI DETAIL TARIK TUNAI
    static let MSISDN_AGEN_KONF_TARIK_TUNAI_DETAIL :String = "msisdn_agen"
    static let TOKEN_KONF_TARIK_TUNAI_DETAIL :String = "token"
    static let PIN_KONF_TARIK_TUNAI_DETAIL :String = "pin"
    static let ACTION_KONFIRMASI_TARIK_TUNAI_DETAIL :String = "posting_tarik_tunai"
    static let MESSAGE_LOG_KONFIRMASI_TARIK_TUNAI_DETAIL :String = "Mencoba Cek Status Terakhir"
    static let LOG_KONFIRMASI_TARIK_TUNAI_DETAIL :String = "Request Cek Status Terakhir"
    
    //JSON KONFIRMASI DETAIL TARIK TUNAI TANPA KARTU
    static let MSISDN_AGEN_KONF_TARIK_TUNAI_TANPA_KARTU_DETAIL :String = "msisdn_agen"
    static let KODE_RESERVASI_TARIK_TUNAI_TP :String = "kode_reservasi"
    static let OTP_TARIK_TUNAI_TP :String = "otp"
    static let PIN_TARIK_TUNAI_TP :String = "pin"
    static let ACTION_TARIK_TUNAI_TP :String = "tarik_tunai_tanpa_kartu"
    
    
    //JSON NOTIFIKASI
    static let ACTION_NOTIFIKASI :String = "notifikasi"
    static let ACTION_RESEND_TOKEN :String = "resend_token"
    
    //JSON PEMBAYRAN/PEMBELIAN
    static let OTP_PEMBAYARAN :String = "token"
    
    //JSON REQUEST TRANSFER
    static let MSISDN_AGEN_REQUEST_TRANSFER :String = "msisdn_agen"
    static let MSISDN_NASABAH_REQUEST_TRANSFER :String = "msisdn_nasabah"
    static let MSISDN_TUJUAN_REQUEST_TRANSFER :String = "msisdn_tujuan"
    static let NOMINAL_REQUEST_TRANSFER :String = "nominal"
    static let ID_BANK_REQUEST_TRANSFER :String = "id_bank"
    static let NO_REK_REQUEST_TRANSFER :String = "no_rekening"
    static let ACTION_REQUEST_TRANSFER :String = "request_transfer_on_us"
    static let ACTION_REQUEST_TRANSFER_ANTAR_BANK :String = "request_transfer_off_us"
    static let ACTION_LIST_BANK :String = "list_bank"
    static let ACTION_REQUEST_TRANSFER_LAKUPANDAI :String = "request_transfer_on_us_lakupandai"
    static let MESSAGE_LOG_REQUEST_TRANSFER :String = "Mencoba Request Transfer"
    static let LOG_REQUEST_TRANSFER :String = "Request Transfer"
    static let TOKEN_REQUEST_TRANSFER :String = "token"
    
    //JSON REQUEST TRANSFER KONFIRMASI
    static let MSISDN_AGEN_REQUEST_TRANSFER_KONFIRMASI :String = "msisdn_agen"
    static let PIN_REQUEST_TRANSFER_KONFIRMASI :String = "pin"
    static let TOKEN_REQUEST_TRANSFER_KONFIRMASI :String = "token"
    static let ACTION_REQUEST_TRANSFER_KONFIRMASI :String = "request_transfer_on_us_pin"
    static let ACTION_REQUEST_TRANSFER_KONFIRMASI_ANTAR_BANK :String = "request_transfer_off_us_pin"
    static let ACTION_REQUEST_TRANSFER_KONFIRMASI_LAKUPANDAI :String = "request_transfer_on_us_pin_lakupandai"
    static let MESSAGE_LOG_REQUEST_TRANSFER_KONFIRMASI :String = "Mencoba Request Transfer Konfirmasi"
    static let LOG_REQUEST_TRANSFER_KONFIRMASI :String = "Request Transfer Konfirmasi"
    
    //JSON TRANSFER KONFIRMASI
    static let MSISDN_AGEN_TRANSFER_KONFIRMASI :String = "msisdn_agen"
    static let TOKEN_TRANSFER_KONFIRMASI :String = "token"
    static let ACTION_TRANSFER_KONFIRMASI :String = "send_token_transfer_on_us"
    static let ACTION_TRANSFER_ANTAR_BANK_KONFIRMASI :String = "send_token_transfer_off_us"
    static let ACTION_TRANSFER_KONFIRMASI_LAKUPANDAI :String = "send_token_transfer_on_us_lakupandai"
    static let MESSAGE_LOG_TRANSFER_KONFIRMASI :String = "Mencoba Konfirmasi Transfer"
    static let LOG_TRANSFER_KONFIRMASI :String = "Request Konfirmasi Transfer"
    
    //JSON TRANSFER KONFIRMASI DETAIL
    static let MSISDN_AGEN_TRANSFER_KONFIRMASI_DETAIL :String = "msisdn_agen"
    static let TOKEN_TRANSFER_KONFIRMASI_DETAIL :String = "token"
    static let PIN_TRANSFER_KONFIRMASI_DETAIL :String = "pin"
    static let ACTION_TRANSFER_KONFIRMASI_DETAIL :String = "posting_transfer_on_us"
    static let ACTION_TRANSFER_ANTAR_BANK_KONFIRMASI_DETAIL :String = "posting_transfer_off_us"
    static let ACTION_TRANSFER_KONFIRMASI_DETAIL_LAKUPANDAI :String = "posting_transfer_on_us_lakupandai"
    static let MESSAGE_LOG_TRANSFER_KONFIRMASI_DETAIL :String = "Mencoba Konfirmasi Transfer Detail"
    static let LOG_TRANSFER_KONFIRMASI_DETAIL :String = "Request Konfirmasi Transfer Detail"
    
    //JSON NOTIFIKASI
    static let NO_RESI :String = "resi"
    static let ID_NOTIF :String = "id_notif"
    static let ACTION_GET_LIST_NOTIF :String = "notifikasi_mobile"
    static let ACTION_GET_DETAIL_TRX :String = "detail_notifikasi_mobile"
    static let ACTION_GET_LIST_NOTIF_AGEN:String = "agen"
    
    
    static let USER_SESSION_AGENT_ID:String = "id_agen"
    static let USER_SESSION_AGENT_NAME:String = "agent_name"
    static let USER_SESSION_USERNAME:String = "username"
    static let USER_SESSION_SLIDER_COUNT:String = "slider_count"
    
    
}
