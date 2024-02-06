//
//  ConstantError.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 04/10/23.
//

import Foundation

struct ConstantError {
    static let MESSAGE : String = "Pesan";
    static let MESSAGE_LOGOUT : String = "Anda Yakin Ingin Keluar?";
    static let MESSAGE_SMS : String = "Data Akan Dikirim Lewat SMS Karena Masalah Jaringan, Ijinkan?";
    static let MESSAGE_YES : String = "Ya";
    static let MESSAGE_NO : String = "Tidak";
    static let MESSAGE_OK : String = "OK";
    static let MESSAGE_FAILED : String = "Gagal Mengirim Data Harap Dicoba Kembali";
    static let MESSAGE_ROOT : String = "Aplikasi tidak bisa digunakan bila Root Device Aktif";


    static let ALERT_FIELD_EMPTY : String = "Mohon Lengkapi Semua Kolom";
    static let ALERT_KTP_LESS_THAN_16 : String = "NIK Harus 16 Angka";
    static let ALERT_PIN_LESS_THAN_6 : String = "Pin Harus 6 Angka";
    static let ALERT_TOKEN_LESS_THAN_6 : String = "Token / OTP Harus 6 Angka";
    static let ALERT_OTP_EMPTY : String = "OTP tidak boleh kosong";
    static let ALERT_NUMBER_LESS_THAN_10 : String = "Nomor HP Minimal 10 Angka";
    static let ALERT_DATE_LESS_THAN_10 : String = "Format Tanggal Salah";
    static let ALERT_USERNAME_EMPTY : String = "Username Tidak Boleh Kosong";
    static let ALERT_KTP_NOT_VALID : String = "Isi Input NIK dengan Benar";
    static let ALERT_NUMBER_NOT_VALID : String = "Isi Input NIK dengan Benar";
    //    static let ALERT_TARIK_TUNAI_LESS_THAN_100 : String = "Tarik Tunai Minimal 100 Rupiah";
    //    static let ALERT_SETOR_TUNAI_LESS_THAN_100 : String = "Setor Tunai Minimal 100 Rupiah";
    static let ALERT_CONF_CODE_EMPTY : String = "Mohon Isi Token";
    static let ALERT_CONF_CODE_LESS_THAN_6 : String = "Token Harus 6 Digit";
    static let ALERT_NOMINAL_INPUT_FALSE : String = "Input Nominal Salah";
    static let ALERT_NO_REK_LESS_THAN_10 : String = "Nomor Rekening Minimal 10 Angka";
    static let ALERT_NOMINAL_LESS_THAN_1 : String = "Jumlah Nominal tidak boleh kurang dari 1 Rupiah";
    static let ALERT_LAYANAN : String = "Silahkan Pilih Layanan";
    static let ALERT_ID_PELANGGAN : String = "ID Pembayaran / Pelanggan Tidak Boleh Kosong";
    static let ALERT_DEBIT_REKENING : String = "Rekening Ponsel Tidak Boleh Kosong";
    static let ALERT_CONNECT : String = "Silahkan Periksa Koneksi Anda";
    static let ALERT_FAILED_READ_RESPONSE : String = "Gagal membaca respon server, mohon coba beberapa saat lagi";
    static let ALERT_SERVER_NOT_RESPONSE : String = "Server tidak merespon, mohon coba beberapa saat lagi";

    static let ALERT_REQPERMISSION_READPHONESTATE : String = "Mohon Ijinkan untuk mengakses Data Smartphone Anda";
}
