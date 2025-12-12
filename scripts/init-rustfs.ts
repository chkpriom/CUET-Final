/**
 * RustFS Bucket Initialization Script
 * 
 * This script initializes the RustFS S3-compatible storage by:
 * 1. Creating the required 'downloads' bucket if it doesn't exist
 * 2. Uploading a health check marker file for storage verification
 * 
 * Usage: node --experimental-transform-types scripts/init-rustfs.ts
 */

import {
  CreateBucketCommand,
  HeadBucketCommand,
  PutObjectCommand,
  S3Client,
} from "@aws-sdk/client-s3";

// Environment configuration
const S3_ENDPOINT = process.env.S3_ENDPOINT ?? "http://localhost:9000";
const S3_ACCESS_KEY_ID = process.env.S3_ACCESS_KEY_ID ?? "rustfsadmin";
const S3_SECRET_ACCESS_KEY =
  process.env.S3_SECRET_ACCESS_KEY ?? "rustfsadmin";
const S3_BUCKET_NAME = process.env.S3_BUCKET_NAME ?? "downloads";
const S3_REGION = process.env.S3_REGION ?? "us-east-1";

console.log("Initializing RustFS S3 Storage...");
console.log(`Endpoint: ${S3_ENDPOINT}`);
console.log(`Bucket: ${S3_BUCKET_NAME}`);
console.log(`Region: ${S3_REGION}`);

// Initialize S3 client with RustFS endpoint
const s3Client = new S3Client({
  endpoint: S3_ENDPOINT,
  region: S3_REGION,
  credentials: {
    accessKeyId: S3_ACCESS_KEY_ID,
    secretAccessKey: S3_SECRET_ACCESS_KEY,
  },
  forcePathStyle: true, // Required for self-hosted S3
});

async function checkBucketExists(): Promise<boolean> {
  try {
    await s3Client.send(
      new HeadBucketCommand({
        Bucket: S3_BUCKET_NAME,
      }),
    );
    return true;
  } catch (err) {
    if (err instanceof Error && err.name === "NotFound") {
      return false;
    }
    // Re-throw other errors (e.g., connection issues)
    throw err;
  }
}

async function createBucket(): Promise<void> {
  console.log(`Creating bucket: ${S3_BUCKET_NAME}...`);
  await s3Client.send(
    new CreateBucketCommand({
      Bucket: S3_BUCKET_NAME,
    }),
  );
  console.log(`✓ Bucket '${S3_BUCKET_NAME}' created successfully`);
}

async function uploadHealthCheckMarker(): Promise<void> {
  console.log("Uploading health check marker...");
  const markerContent = JSON.stringify({
    initialized: true,
    timestamp: new Date().toISOString(),
    purpose: "Health check marker for storage connectivity verification",
  });

  await s3Client.send(
    new PutObjectCommand({
      Bucket: S3_BUCKET_NAME,
      Key: "__health_check_marker__",
      Body: markerContent,
      ContentType: "application/json",
    }),
  );
  console.log("✓ Health check marker uploaded successfully");
}

async function main(): Promise<void> {
  try {
    // Check if bucket exists
    const bucketExists = await checkBucketExists();

    if (bucketExists) {
      console.log(`✓ Bucket '${S3_BUCKET_NAME}' already exists`);
    } else {
      await createBucket();
    }

    // Upload health check marker
    await uploadHealthCheckMarker();

    console.log("\n✓ RustFS initialization completed successfully!");
    console.log(`\nYou can now:`);
    console.log(`  - Access RustFS Console: http://localhost:9001`);
    console.log(`  - Login credentials: rustfsadmin / rustfsadmin`);
    console.log(`  - Test health endpoint: curl http://localhost:3000/health`);

    // Clean up
    s3Client.destroy();
    process.exit(0);
  } catch (err) {
    console.error("\n✗ Error initializing RustFS:");
    if (err instanceof Error) {
      console.error(`  ${err.message}`);
      console.error("\nTroubleshooting:");
      console.error(
        "  1. Ensure RustFS is running: docker compose -f docker/compose.dev.yml ps",
      );
      console.error(`  2. Verify endpoint is accessible: curl ${S3_ENDPOINT}`);
      console.error(
        "  3. Check credentials match those in docker compose file",
      );
    } else {
      console.error(err);
    }
    s3Client.destroy();
    process.exit(1);
  }
}

main();
