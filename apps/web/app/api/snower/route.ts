import { NextResponse } from "next/server";
import { SnowerAPI } from "@/lib/snower";

export const revalidate = 1800; // 30 minutes

export async function GET() {
	try {
		const api = new SnowerAPI();
		const monitors = await api.getAllMonitorData();
		return NextResponse.json(monitors);
	} catch (error) {
		console.error("Error fetching monitor data:", error);
		return NextResponse.json(
			{ error: "Failed to fetch monitor data" },
			{ status: 500 }
		);
	}
}
