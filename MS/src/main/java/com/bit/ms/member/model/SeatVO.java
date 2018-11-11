package com.bit.ms.member.model;

import org.apache.ibatis.type.Alias;

@Alias("seatVO")
public class SeatVO {

	private int seat_id; // 좌석 번호
	private int seat_pay; // 좌석 비용
	private int seat_update_time; // 좌석 수정시간
	private int seat_add_time; // 좌석 충전시간
	private String user_id; // 회원 아이디
	private int store_id; // 매장 번호

	private String seat_qr; // 좌석 QR코드
//	private MutlipartFile qr_file;

	public int getSeat_id() {
		return seat_id;
	}

	public void setSeat_id(int seat_id) {
		this.seat_id = seat_id;
	}

	public String getSeat_qr() {
		return seat_qr;
	}

	public void setSeat_qr(String seat_qr) {
		this.seat_qr = seat_qr;
	}

	public int getSeat_pay() {
		return seat_pay;
	}

	public void setSeat_pay(int seat_pay) {
		this.seat_pay = seat_pay;
	}

	public int getSeat_update_time() {
		return seat_update_time;
	}

	public void setSeat_update_time(int seat_update_time) {
		this.seat_update_time = seat_update_time;
	}

	public int getSeat_add_time() {
		return seat_add_time;
	}

	public void setSeat_add_time(int seat_add_time) {
		this.seat_add_time = seat_add_time;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public int getStore_id() {
		return store_id;
	}

	public void setStore_id(int store_id) {
		this.store_id = store_id;
	}

	@Override
	public String toString() {
		return "SeatVO [seat_id=" + seat_id + ", seat_qr=" + seat_qr + ", seat_pay=" + seat_pay + ", seat_update_time="
				+ seat_update_time + ", seat_add_time=" + seat_add_time + ", user_id=" + user_id + ", store_id="
				+ store_id + "]";
	}
}