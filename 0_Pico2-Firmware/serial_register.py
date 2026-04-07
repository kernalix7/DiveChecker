#!/usr/bin/env python3
"""
DiveChecker Serial Number Registry

USB에 연결된 DiveChecker 디바이스의 시리얼 번호를 읽어
CSV 파일에 등록합니다. (정품 등록용)

사용법:
    python3 serial_register.py              # 기본 (divechecker_serials.csv)
    python3 serial_register.py -o my.csv    # 출력 파일 지정
    python3 serial_register.py --list       # 등록된 시리얼 목록 출력
"""

import csv
import os
import sys
import glob
import argparse
from datetime import datetime

DEFAULT_CSV = "divechecker_serials.csv"

# USB identifiers
USB_VID = "1209"
USB_PID = "dc01"
USB_PRODUCT_NAME = "DiveChecker"


def find_divechecker_serials():
    """sysfs에서 DiveChecker 디바이스 시리얼 번호 탐색"""
    found = []
    for device_path in glob.glob("/sys/bus/usb/devices/*/"):
        try:
            vid_path = os.path.join(device_path, "idVendor")
            pid_path = os.path.join(device_path, "idProduct")
            serial_path = os.path.join(device_path, "serial")
            product_path = os.path.join(device_path, "product")

            if not all(os.path.exists(p) for p in [vid_path, pid_path, serial_path]):
                continue

            with open(vid_path) as f:
                vid = f.read().strip()
            with open(pid_path) as f:
                pid = f.read().strip()

            if vid == USB_VID and pid == USB_PID:
                with open(serial_path) as f:
                    serial = f.read().strip()
                product = ""
                if os.path.exists(product_path):
                    with open(product_path) as f:
                        product = f.read().strip()
                found.append((serial, product))
        except (PermissionError, IOError):
            continue
    return found


def load_existing_serials(csv_file):
    """CSV에서 기존 시리얼 목록 로드"""
    serials = {}
    if os.path.exists(csv_file):
        with open(csv_file, "r", newline="") as f:
            reader = csv.DictReader(f)
            for row in reader:
                serials[row["serial"]] = row.get("registered_at", "")
    return serials


def append_serial(csv_file, serial):
    """CSV에 시리얼 추가"""
    file_exists = os.path.exists(csv_file)
    with open(csv_file, "a", newline="") as f:
        writer = csv.writer(f)
        if not file_exists:
            writer.writerow(["serial", "registered_at"])
        writer.writerow([serial, datetime.now().strftime("%Y-%m-%d %H:%M:%S")])


def list_serials(csv_file):
    """등록된 시리얼 목록 출력"""
    serials = load_existing_serials(csv_file)
    if not serials:
        print("등록된 시리얼이 없습니다.")
        return
    print(f"총 {len(serials)}대 등록됨 ({csv_file})")
    print("-" * 40)
    for i, (serial, date) in enumerate(serials.items(), 1):
        print(f"  {i:3d}. {serial}  ({date})")


def main():
    parser = argparse.ArgumentParser(description="DiveChecker 시리얼 번호 등록")
    parser.add_argument("-o", "--output", default=DEFAULT_CSV, help="CSV 파일 경로")
    parser.add_argument("--list", action="store_true", help="등록된 시리얼 목록 출력")
    args = parser.parse_args()

    if args.list:
        list_serials(args.output)
        return

    devices = find_divechecker_serials()

    if not devices:
        print("DiveChecker 디바이스를 찾을 수 없습니다.")
        print("USB-C 케이블로 연결되어 있는지 확인하세요.")
        sys.exit(1)

    existing = load_existing_serials(args.output)

    for serial, product in devices:
        print(f"디바이스: {product}")
        print(f"시리얼 : {serial}")

        if serial in existing:
            print(f"→ 이미 등록됨 (등록일: {existing[serial]})")
        else:
            append_serial(args.output, serial)
            print(f"→ 등록 완료!")

    total = len(load_existing_serials(args.output))
    print(f"\n총 등록: {total}대")


if __name__ == "__main__":
    main()
